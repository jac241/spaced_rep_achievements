import React, {useEffect} from "react"
import {useDispatch, useSelector} from "react-redux"
import {fetchEntries} from "chase_mode/actions"
import { createCableSubscription } from "./cableSubscription";


let cableSubscription = null


const ChaseMode = ({ userId, reifiedLeaderboardId }) => {
  const dispatch = useDispatch()
  useEffect(() => {
    dispatch(fetchEntries(reifiedLeaderboardId))
    cableSubscription = createCableSubscription(reifiedLeaderboardId, dispatch)

    return function cleanup() {
      cableSubscription && cableSubscription.unsubscribe()
    }
  }, [])

  return (
    <table id="rivalry">
      <RivalryUser userId={userId} />
    </table>
  )
}


const RivalryUser = ({ userId }) => {
  let entriesArePresent = useSelector(state => Object.keys(state.entries.entities).length > 0)
  let userEntry = useSelector(
    state => Object.values(state.entries.entities).find(entry => entry.relationships.user.data.id === userId)
  )
  let userEntryIndex = useSelector(
    state => userEntry ? state.entries.ids.findIndex(id => id === userEntry.id) : null
  )
  let rivalEntry = useSelector((state) => {
    if (userEntryIndex >= 1) {
      let rivalId = state.entries.ids[userEntryIndex - 1]
      return state.entries.entities[rivalId]
    } else {
      return null
    }
  })
  let rivalUser = useSelector((state) => (
    rivalEntry ? state.api.user[rivalEntry.relationships.user.data.id] : null
  ))

  if (userEntry && userEntry.attributes.score > 0) {
    return (
      <React.Fragment>
        <td id="rivalry_user">
          { `Score: ${userEntry.attributes.score}` }
          <br/>
          { `Your Rank: ${userEntryIndex + 1} `}
        </td>
        { rivalEntry && rivalUser && <Rival rivalEntry={rivalEntry} rivalUser={rivalUser} /> }
      </React.Fragment>
    )
  } else if (entriesArePresent) {
    return (
      <td id="rivalry_user">
        Start reviewing to become ranked!
      </td>
    )
  }
}


const Rival = ({ rivalEntry, rivalUser }) => {
  const rivalDisplayText = `${rivalUser.attributes.username} - ${rivalEntry.attributes.score}`

  return (
    <td id="rivalry_rival">
      Rival:&nbsp;
      { rivalEntry.attributes.online ? (
          <span title="Online" style="color: #0275d8">
            { rivalDisplayText }
          </span>
        ) : (
           rivalDisplayText
        )
      }
    </td>
  )
}

export default ChaseMode
