import { createSlice } from '@reduxjs/toolkit'
import normalize from 'json-api-normalizer'
import merge from 'lodash.merge'

const initialState = {
  entry: {},
  family: {},
  group: {},
  medalStatistic: {},
  reifiedLeaderboard: {},
  user: {},
  medal: {},
}

const apiSlice = createSlice({
  name: 'leaderboard',
  initialState: initialState,
  reducers: {
    receiveData(state, { payload }) {
      Object.keys(payload).forEach((entityType) => {
        const payloadEntities = payload[entityType]
        for (const entityId in payloadEntities) {
          const existingEntity = state[entityType][entityId]
          if (existingEntity) {
            state[entityType][entityId] = merge(existingEntity, payloadEntities[entityId])
          } else {
            state[entityType][entityId] = payloadEntities[entityId]
          }
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
