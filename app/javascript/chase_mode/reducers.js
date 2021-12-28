import { combineReducers } from "redux"
import apiReducer from "../realtime_leaderboard/leaderboard/apiSlice"
import entryReducer from "../realtime_leaderboard/leaderboard/entriesSlice"
import cableReducer from "./cableSlice"
import chaseModeConfigReducer from "./chaseModeConfigSlice"
import membershipsReducer from "./membershipsSlice"

export default combineReducers({
  api: apiReducer,
  entries: entryReducer,
  cable: cableReducer,
  chaseModeConfig: chaseModeConfigReducer,
  memberships: membershipsReducer,
})
