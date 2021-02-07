import client from 'chase_mode/apiClient.js.erb'
import { receiveData, receiveJsonApiData } from 'realtime_leaderboard/leaderboard/apiSlice'

export const fetchEntries = (reifiedLeaderboardId) => async (dispatch) => {
  try {
    let entriesResponse = await client.get(
      `/api/v1/entries?reified_leaderboard_id=${reifiedLeaderboardId}`,
    )
    dispatch(receiveJsonApiData(entriesResponse.data))
  } catch (err) {
    console.log(err)
  }
}
