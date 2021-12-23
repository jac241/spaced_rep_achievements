import { combineReducers } from "redux"
import apiReducer from "realtime_leaderboard/leaderboard/apiSlice"
import entryReducer from "realtime_leaderboard/leaderboard/entriesSlice"
import cableReducer from "chase_mode/cableSlice"
import chaseModeConfigReducer from "chase_mode/chaseModeConfigSlice"
import membershipsReducer from "chase_mode/membershipsSlice"

export default combineReducers({
  api: apiReducer,
  entries: entryReducer,
  cable: cableReducer,
  chaseModeConfig: chaseModeConfigReducer,
  memberships: membershipsReducer,
})
