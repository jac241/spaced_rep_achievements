import { createSlice, createEntityAdapter } from "@reduxjs/toolkit"
import { upsertIfUpdated } from "../reducerUtil"
import { receiveData, receiveJsonApiData } from "./apiSlice"

const entriesAdapter = createEntityAdapter({
  sortComparer: (a, b) => b.attributes.score - a.attributes.score,
})

const entriesSlice = createSlice({
  name: "entries",
  initialState: entriesAdapter.getInitialState({
    isRequestingCachedEntries: false,
    isRequestingEntries: false,
  }),
  reducers: {
    getCachedEntriesStart(state, action) {
      state.isRequestingCachedEntries = true
    },
    getCachedEntriesSuccess(state, action) {
      state.isRequestingCachedEntries = false
    },
    receiveEntries(state, { payload = {} }) {
      upsertMany(state, payload)
    },
    getEntriesStart(state, action) {
      state.isRequestingEntries = true
    },
    getEntriesFinished(state, action) {
      state.isRequestingEntries = false
    },
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

export const {
  receiveEntries,
  getCachedEntriesStart,
  getCachedEntriesSuccess,
  getEntriesStart,
  getEntriesFinished,
} = entriesSlice.actions
export default entriesSlice.reducer
