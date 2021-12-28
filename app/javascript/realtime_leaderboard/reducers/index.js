import { combineReducers } from "redux"
import apiReducer from "../leaderboard/apiSlice"
import entriesReducer from "../leaderboard/entriesSlice"
import topMedalsReducer from "../leaderboard/topMedalsSlice"
import cableReducer from "../../chase_mode/cableSlice"

export default combineReducers({
  api: apiReducer,
  entries: entriesReducer,
  topMedals: topMedalsReducer,
  cable: cableReducer,
})
