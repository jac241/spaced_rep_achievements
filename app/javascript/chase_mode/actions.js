import client from 'chase_mode/apiClient.js.erb'
import { receiveData, receiveJsonApiData } from 'realtime_leaderboard/leaderboard/apiSlice'
import { getEntriesStart, getEntriesFinished } from 'realtime_leaderboard/leaderboard/entriesSlice'

export const fetchEntries = (queryParams) => async (dispatch) => {
  try {
    dispatch(getEntriesStart())
    let entriesResponse = await client.get(
      `/api/v1/entries?${queryString(queryParams)}`,
    )
    dispatch(receiveJsonApiData(entriesResponse.data))
  } catch (err) {
    console.log(err)
  } finally {
    dispatch(getEntriesFinished())
  }
}

const queryString = params => Object.keys(params).map(key => key + '=' + params[key]).join('&')
