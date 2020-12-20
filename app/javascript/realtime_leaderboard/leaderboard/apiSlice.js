import { createSlice } from '@reduxjs/toolkit'
import { receiveEntries } from './entriesSlice'

const initialState = {
  entry: {},
  family: {},
  group: {},
  medalStatistic: {},
  reifiedLeaderboard: {},
  user: {},
}

const leaderboardSlice = createSlice({
  name: 'leaderboard',
  initialState: initialState,
  reducers: {
    hydrate(state, { payload }) {
      Object.keys(state).forEach(key => state[key] = payload[key])
    }
  }
})

export const hydrate = (initialData) => (dispatch) => {
  dispatch(receiveEntries(initialData.entry))
  dispatch(leaderboardSlice.actions.hydrate(initialData))
}

export default leaderboardSlice.reducer
