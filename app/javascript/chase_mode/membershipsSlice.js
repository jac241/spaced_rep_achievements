import { createSlice } from "@reduxjs/toolkit"

const initialState = {
  isRequestingMemberships: false,
}

const membershipsSlice = createSlice({
  name: "memberships",
  initialState,
  reducers: {
    getMembershipsStart(state) {
      state.isRequestingMemberships = true
    },
    getMembershipsFinished(state) {
      state.isRequestingMemberships = false
    },
  },
})

export const { getMembershipsStart, getMembershipsFinished } =
  membershipsSlice.actions

export default membershipsSlice.reducer
