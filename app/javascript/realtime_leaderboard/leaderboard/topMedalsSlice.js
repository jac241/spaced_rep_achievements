import { createSlice } from '@reduxjs/toolkit'
import { receiveData } from 'realtime_leaderboard/leaderboard/apiSlice'
import merge from 'lodash.merge'

const initialState = {
  topMedalsbyEntryId: {},
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
        ensureValuesForEntries(state, payload.entry)
      }
    })
  }
})

const addMedalStatistics = (state, medalStatisticsById) => {
  for (const [id, newMedalStatistic] of Object.entries(medalStatisticsById)) {
    upsertIntoEntities(state, newMedalStatistic)
    groupTopMedalsByEntryId(state, newMedalStatistic)
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

const groupTopMedalsByEntryId = (state, newMedalStatistic) => {
  const entryId = newMedalStatistic.relationships.entry.data.id

  ensureValueForEntryId(state, entryId)
  insertInOrder(state, state.topMedalsbyEntryId[entryId], newMedalStatistic)
}

const ensureValuesForEntries = (state, entriesById) => {
  for (const [entryId, entry] of Object.entries(entriesById)) {
    ensureValueForEntryId(state, entryId)
  }
}

const ensureValueForEntryId = (state, entryId) => {
  if (state.topMedalsbyEntryId[entryId] === undefined) {
    state.topMedalsbyEntryId[entryId] = []
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
