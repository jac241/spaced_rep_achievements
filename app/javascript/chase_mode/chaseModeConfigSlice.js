import { createSlice } from "@reduxjs/toolkit"

const initialState = {
  isRequestingChaseModeConfig: false,
  id: null,
}

const chaseModeConfigSlice = createSlice({
  name: "chaseModeConfig",
  initialState,
  reducers: {
    getChaseModeConfigStart(state) {
      state.isRequestingChaseModeConfig = true
    },
    getChaseModeConfigFinished(state) {
      state.isRequestingChaseModeConfig = false
    },
  },
})

export const { getChaseModeConfigStart, getChaseModeConfigFinished } =
  chaseModeConfigSlice.actions

export default chaseModeConfigSlice.reducer
