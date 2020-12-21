import { createSlice } from '@reduxjs/toolkit'
import normalize from 'json-api-normalizer'

const initialState = {
  entry: {},
  family: {},
  group: {},
  medalStatistic: {},
  reifiedLeaderboard: {},
  user: {},
}

const apiSlice = createSlice({
  name: 'leaderboard',
  initialState: initialState,
  reducers: {
    receiveData(state, { payload }) {
      Object.keys(payload).forEach((entityType) => {
        const payloadEntities = payload[entityType]
        for (const entityId in payloadEntities) {
          state[entityType][entityId] = payloadEntities[entityId]
        }
      })
    }
  }
})

export const { receiveData } = apiSlice.actions

export const receiveJsonApiData = (data) => (dispatch) => {
  dispatch(apiSlice.actions.receiveData(normalize(data)))
}

export default apiSlice.reducer
