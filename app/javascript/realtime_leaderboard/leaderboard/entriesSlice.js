import { createSlice } from '@reduxjs/toolkit'

const entriesSlice = createSlice({
  name: 'entries',
  initialState: [],
  reducers: {
    receiveEntry(state, action) {
      return state
    }
  }
})

export const { receiveEntry } = entriesSlice.actions

export default entriesSlice.reducer
