import client from 'chase_mode/apiClient.js.erb'
import { receiveData, receiveJsonApiData } from 'realtime_leaderboard/leaderboard/apiSlice'
import { getEntriesStart, getEntriesFinished } from 'realtime_leaderboard/leaderboard/entriesSlice'

export const fetchEntries = (reifiedLeaderboardId) => async (dispatch) => {
  try {
    dispatch(getEntriesStart())
    let entriesResponse = await client.get(
      `/api/v1/entries?reified_leaderboard_id=${reifiedLeaderboardId}`,
    )
    dispatch(receiveJsonApiData(entriesResponse.data))
  } catch (err) {
    console.log(err)
  } finally {
    dispatch(getEntriesFinished())
  }
}
