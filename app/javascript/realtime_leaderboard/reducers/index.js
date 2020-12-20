import { combineReducers } from 'redux'
import entriesReducer from 'realtime_leaderboard/leaderboard/entriesSlice'

export default combineReducers({
  entries: entriesReducer,
})
