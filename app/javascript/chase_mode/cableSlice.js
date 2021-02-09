import { createSlice } from '@reduxjs/toolkit'

const cableSlice = createSlice({
  name: 'cable',
  initialState: {
    connectionStatus: 'connecting',
  },
  reducers: {
    cableWasDisconnected(state, action) {
      state.connectionStatus = 'disconnected'
    },
    cableDidConnect(state, action) {
      state.connectionStatus = 'connected'
    },
  }
})

export const {
  cableWasDisconnected,
  cableDidConnect,
} = cableSlice.actions

export default cableSlice.reducer
