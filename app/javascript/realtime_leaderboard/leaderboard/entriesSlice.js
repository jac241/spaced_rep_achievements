import { createSlice, createEntityAdapter } from '@reduxjs/toolkit'
import { upsertIfUpdated } from 'realtime_leaderboard/reducerUtil'
import { receiveData } from 'realtime_leaderboard/leaderboard/apiSlice'

const entriesAdapter = createEntityAdapter({
  sortComparer: (a, b) => b.attributes.score - a.attributes.score
})

const entriesSlice = createSlice({
  name: 'entries',
  initialState: entriesAdapter.getInitialState(),
  reducers: {
    receiveEntries(state, { payload = {} }) {
      upsertMany(state, payload)
    }
  },
  extraReducers: (builder) => {
    builder.addCase(receiveData, (state, { payload }) => {
      if (payload.entry) {
        upsertMany(state, payload.entry)
      }
    })
  },
})

const upsertMany = (state, newEntries) => {
  for (const id in newEntries) {
    upsertIfUpdated(state, entriesAdapter, newEntries[id])
  }
}

export const { receiveEntries } = entriesSlice.actions
export default entriesSlice.reducer
