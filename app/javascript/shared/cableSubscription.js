import { useEffect, useRef } from "react"
import { receiveJsonApiData } from "../realtime_leaderboard/leaderboard/apiSlice"
import consumer from "../channels/ankiConsumer.js"
import { cableWasDisconnected, cableDidConnect } from "../chase_mode/cableSlice"

export const createCableSubscription = (reifiedLeaderboardId, dispatch) => {
  return consumer.subscriptions.create(
    {
      channel: "RealtimeLeaderboardsChannel",
      leaderboard_id: reifiedLeaderboardId,
    },
    {
      connected() {
        // Called when the subscription is ready for use on the server
        console.log("realtime lb connected" + reifiedLeaderboardId)
        dispatch(cableDidConnect())
      },

      disconnected() {
        dispatch(cableWasDisconnected())
      },

      received(action) {
        if (action.type === "api/receiveJsonApiData") {
          dispatch(receiveJsonApiData(action.payload))
        }
      },
    }
  )
}

export const useCableReconnected = (connectionStatus, callback) => {
  const prevConnectionStatus = usePrevious(connectionStatus)

  useEffect(() => {
    if (
      connectionStatus === "connected" &&
      prevConnectionStatus === "disconnected"
    ) {
      callback()
    }
  }, [connectionStatus])
}

const usePrevious = (value) => {
  const ref = useRef()
  useEffect(() => {
    ref.current = value
  })
  return ref.current
}
