import { createSlice, createEntityAdapter } from '@reduxjs/toolkit'

const entriesAdapter = createEntityAdapter({
  sortComparer: (a, b) => b.attributes.score - a.attributes.score
})

const entriesSlice = createSlice({
  name: 'entries',
  initialState: entriesAdapter.getInitialState(),
  reducers: {
    receiveEntries(state, action) {
      if (action.payload !== undefined) {
        for (let [id, entry] of Object.entries(action.payload)) {
          if (state.entities[id] !== undefined) {
            if (entry.updatedAt > state.entities[id].updatedAt) {
              entriesAdapter.upsertOne(state, entry)
            }
          } else {
            entriesAdapter.addOne(state, entry)
          }
        }
      }
    }
  }
})

export const { receiveEntries } = entriesSlice.actions
export default entriesSlice.reducer
