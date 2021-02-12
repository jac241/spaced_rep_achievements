import React, { useEffect } from "react"
import { useDispatch, useSelector } from "react-redux"

import { fetchEntries } from "chase_mode/actions"
import Table from '../leaderboard/Table'
import { createCableSubscription, useCableReconnected } from "shared/cableSubscription";
import { findMostRecentEntryUpdatedAt, compareDates } from "shared/entriesSelectors";

let cableSubscription = null

const App = ({ reifiedLeaderboardId }) => {
  const dispatch = useDispatch()
  const connectionStatus = useSelector(state => state.cable.connectionStatus)
  const mostRecentEntryUpdatedAt = useSelector(findMostRecentEntryUpdatedAt, compareDates)

  useEffect(() => {
    dispatch(fetchEntries({ reified_leaderboard_id: reifiedLeaderboardId, include: "top_medals" }))
    cableSubscription = createCableSubscription(reifiedLeaderboardId, dispatch)
  }, [])

  useCableReconnected(connectionStatus, () => {
    console.log(`Reconnected. Fetching entries since ${mostRecentEntryUpdatedAt}`)
    dispatch(
      fetchEntries(
        {
          reified_leaderboard_id: reifiedLeaderboardId,
          updated_since: mostRecentEntryUpdatedAt.toJSON(),
          include: "top_medals",
        }
      )
    )
  })

  return (
    <Table />
  )
}

export default App
