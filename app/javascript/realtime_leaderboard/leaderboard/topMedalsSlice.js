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
  const getScore = medalStatisticId => state.entities[medalStatisticId].attributes.score
  const comparator = (a, b) =>  b - a
  const findInsertionIndex = (array, newItem, getAttr, comparator) => {
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


  let medalsOldIndex = array.findIndex(id => id === newMedalStatistic.id);
  //console.log(`medals old index: ${medalsOldIndex}`)

  const medalWouldNotMakeTopFive = () => {
    return medalsOldIndex === -1 // medal not in array
      && array.length == 5
      && getScore(array[4]) >= getScore(newMedalStatistic.id)
  }
  //console.log(newMedalStatistic.id, `incoming score ${getScore(newMedalStatistic.id)}`)
  //console.log(array.map(i => i))
  //console.log(array.map(getScore))

  if (medalWouldNotMakeTopFive()) {
    //console.log('medal would not make top five')
    return
  }

  const insertionIndex = findInsertionIndex(array, newMedalStatistic, getScore, comparator)
  //console.log('insertionIndex: ', insertionIndex)

  if (medalsOldIndex > -1) {
    if (medalsOldIndex == insertionIndex) {
      return
    }

    if (insertionIndex < medalsOldIndex) { // gained points, increasing medal rank, will move old down when we insert
      array.splice(medalsOldIndex, 1)
      array.splice(insertionIndex, 0, newMedalStatistic.id)
    }

    if (insertionIndex > medalsOldIndex) {
      array.splice(insertionIndex, 0, newMedalStatistic.id)
      array.splice(medalsOldIndex, 1)
    }
  } else {
    array.splice(insertionIndex, 0, newMedalStatistic.id)
  }
  while (array.length > 5) {
    array.pop()
  }
}

export default topMedalsSlice.reducer
