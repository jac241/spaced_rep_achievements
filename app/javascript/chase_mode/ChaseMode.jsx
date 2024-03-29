import React, { useEffect } from "react"
import { useDispatch, useSelector } from "react-redux"
import { fetchEntries, initializeChaseMode } from "./actions"
import {
  createCableSubscription,
  useCableReconnected,
} from "../shared/cableSubscription"
import {
  findMostRecentEntryUpdatedAt,
  compareDates,
  selectEntriesArePresent,
  selectUserEntry,
  selectUserEntryIndex,
  selectRivalEntry,
  selectUserById,
  selectChaseModeConfig,
  selectGroupsById,
} from "../shared/entriesSelectors"

import { host } from "./apiClient.js"
import SettingsIcon from "./icons/settings.svg"
import pluralize from "pluralize"
import "./ChaseMode.scss"

let cableSubscription = null

const ChaseMode = ({ userId, reifiedLeaderboardId }) => {
  const dispatch = useDispatch()
  const connectionStatus = useSelector((state) => state.cable.connectionStatus)
  const mostRecentEntryUpdatedAt = useSelector(
    findMostRecentEntryUpdatedAt,
    compareDates
  )

  useEffect(() => {
    dispatch(
      initializeChaseMode({ reified_leaderboard_id: reifiedLeaderboardId })
    )

    cableSubscription = createCableSubscription(reifiedLeaderboardId, dispatch)

    return function cleanup() {
      console.log("Chase Mode being unmounted")
      cableSubscription && cableSubscription.unsubscribe()
    }
  }, [])

  useCableReconnected(connectionStatus, () => {
    console.log(
      `Reconnected. Fetching entries since ${mostRecentEntryUpdatedAt}`
    )
    dispatch(
      fetchEntries({
        reified_leaderboard_id: reifiedLeaderboardId,
        updated_since: mostRecentEntryUpdatedAt.toJSON(),
      })
    )
  })

  const cableIsConnected = connectionStatus === "connected"
  const styles = cableIsConnected ? "" : "color: silver"

  return (
    <table id="rivalry" style={styles}>
      {cableIsConnected ? (
        <Rivalry userId={userId} />
      ) : (
        "Connecting to AnkiAchievements.com..."
      )}
    </table>
  )
}

const Rivalry = ({ userId }) => {
  let entriesArePresent = useSelector(selectEntriesArePresent)
  const userEntry = useSelector((state) => selectUserEntry(state, userId))
  const userEntryIndex = useSelector((state) =>
    selectUserEntryIndex(state, userEntry)
  )
  const rivalEntry = useSelector((state) =>
    selectRivalEntry(state, userEntryIndex)
  )

  const rivalUser = useSelector((state) =>
    selectUserById(state, rivalEntry?.relationships?.user?.data?.id)
  )

  let isRequestingEntries = useSelector(
    (state) => state.entries.isRequestingEntries
  )

  if (userEntry && userEntry.attributes.score > 0) {
    return (
      <React.Fragment>
        <td id="rivalry_user">
          <Settings />
          <br />
          {`Score: ${userEntry.attributes.score}`}
          <br />
          {`Your Rank: ${userEntryIndex + 1} `}
        </td>
        <RightPanel rivalEntry={rivalEntry} rivalUser={rivalUser} />
      </React.Fragment>
    )
  } else if (!isRequestingEntries && !userEntry) {
    return (
      <React.Fragment>
        <Settings />
        <br />
        <td id="rivalry_user">Start reviewing to become ranked!</td>
      </React.Fragment>
    )
  }
}

const RightPanel = ({ rivalEntry, rivalUser }) => {
  return (
    <td id="rivalry_rival" className>
      <br />
      {rivalEntry && rivalUser && (
        <Rival rivalEntry={rivalEntry} rivalUser={rivalUser} />
      )}
      <SettingsDisplay />
    </td>
  )
}

const Rival = ({ rivalEntry, rivalUser }) => {
  const rivalDisplayText = `${rivalUser.attributes.username} - ${rivalEntry.attributes.score}`

  return (
    <React.Fragment>
      Rival:&nbsp;
      {rivalEntry.attributes.online ? (
        <span title="Online" style="color: #0275d8">
          {rivalDisplayText}
        </span>
      ) : (
        rivalDisplayText
      )}
    </React.Fragment>
  )
}

const Settings = ({}) => {
  return (
    <a href={`https://ankiachievements.com/chase_mode_settings/edit`}>
      <SettingsIcon height="12" width="12" alt="Settings" />
    </a>
  )
}

const SettingsDisplay = ({}) => {
  const chaseModeConfig = useSelector(selectChaseModeConfig)
  const groups = useSelector(selectGroupsById)
  console.log({ chaseModeConfig })
  let inner = ""
  if (
    chaseModeConfig?.attributes?.onlyShowActiveUsers ||
    chaseModeConfig?.attributes?.groupIds?.length > 0
  ) {
    inner += "Only showing"
    if (chaseModeConfig.attributes.onlyShowActiveUsers) {
      inner += " active"
    }
    inner += " users"
    if (
      chaseModeConfig.attributes.groupIds.length > 0 &&
      Object.keys(groups).length > 0
    ) {
      inner += ` from ${pluralize(
        "group",
        chaseModeConfig.attributes.groupIds
      )}:`
      chaseModeConfig.attributes.groupIds.forEach((groupId) => {
        const group = groups[groupId]
        if (group) {
          inner += ` ${group.attributes.tag}`
        }
      })
    }
  }
  return <div className={"settings_display"}>{inner}</div>
}

export default ChaseMode
