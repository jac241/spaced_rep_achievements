import { createSlice } from '@reduxjs/toolkit'
import { receiveData } from 'realtime_leaderboard/leaderboard/apiSlice'
import merge from 'lodash.merge'

const initialState = {
  topMedalsbyUserId: {},
  entities: {}
}

const topMedalsSlice = createSlice({
  name: 'topMedals',
  initialState: initialState,
  extraReducers: (builder) => {
    builder.addCase(receiveData, (state, { payload }) => {
      if (payload.medalStatistic) {
        addMedalStatistics(state, payload.medalStatistic)
      }
      if (payload.user) {
        ensureEntryForUsers(state, payload.user)
      }
    })
  }
})

const addMedalStatistics = (state, medalStatisticsById) => {
  for (const [id, newMedalStatistic] of Object.entries(medalStatisticsById)) {
    upsertIntoEntities(state, newMedalStatistic)
    groupTopMedalsByUserId(state, newMedalStatistic)
  }
}

const upsertIntoEntities = (state, newEntity) => {
  const existingEntity = state.entities[newEntity.id]
  if (existingEntity) {
    state.entities[newEntity.id] = merge(existingEntity, newEntity)
  } else {
    state.entities[newEntity.id] = newEntity
  }
}

const groupTopMedalsByUserId = (state, newMedalStatistic) => {
  const userId = newMedalStatistic.relationships.user.data.id

  ensureEntryForUser(state, userId)
  insertInOrder(state, state.topMedalsbyUserId[userId], newMedalStatistic)
}

const ensureEntryForUsers = (state, usersById) => {
  for (const [id, user] of Object.entries(usersById)) {
    ensureEntryForUser(state, id)
  }
}

const ensureEntryForUser = (state, userId) => {
  if (state.topMedalsbyUserId[userId] === undefined) {
    state.topMedalsbyUserId[userId] = []
  }
}

const insertInOrder = (state, array, newMedalStatistic) => {
  const getAttr = medalStatisticId => state.entities[medalStatisticId].attributes.score

  const comparator = (a, b) =>  b - a
  const insertionIndex = (array, newItem, getAttr, comparator) => {
    var low = 0,
      high = array.length;

    const newValue = getAttr(newItem.id)

    while (low < high) {
      var mid = low + high >>> 1;
      if (comparator(getAttr(array[mid]), newValue) < 0) {
        low = mid + 1
      } else {
        high = mid;
      }
    }
    return low;
  }

  const index = insertionIndex(array, newMedalStatistic, getAttr, comparator)
  if (!inSortedArray(array, index, newMedalStatistic.id)) {
    array.splice(index, 0, newMedalStatistic.id)
  }
}

const inSortedArray = (array, index, value) => {
  return array[index] === value || (index > 0 && array[index - 1] === value) || (index < array.length - 1 && array[index + 1] === value)
}

export default topMedalsSlice.reducer
