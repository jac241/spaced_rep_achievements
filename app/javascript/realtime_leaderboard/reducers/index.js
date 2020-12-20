import { combineReducers } from 'redux'
import apiReducer from 'realtime_leaderboard/leaderboard/apiSlice'
import entriesReducer from 'realtime_leaderboard/leaderboard/entriesSlice'

export default combineReducers({
  api: apiReducer,
  entries: entriesReducer,
})
