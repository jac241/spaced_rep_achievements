import { combineReducers } from 'redux'
import apiReducer from 'realtime_leaderboard/leaderboard/apiSlice'
import entriesReducer from 'realtime_leaderboard/leaderboard/entriesSlice'
import topMedalsReducer from 'realtime_leaderboard/leaderboard/topMedalsSlice'
import cableReducer from 'chase_mode/cableSlice'

export default combineReducers({
  api: apiReducer,
  entries: entriesReducer,
  topMedals: topMedalsReducer,
  cable: cableReducer,
})
