import client from "chase_mode/apiClient.js.erb"
import { receiveJsonApiData } from "realtime_leaderboard/leaderboard/apiSlice"
import {
  getEntriesStart,
  getEntriesFinished,
} from "realtime_leaderboard/leaderboard/entriesSlice"
import {
  getChaseModeConfigFinished,
  getChaseModeConfigStart,
} from "chase_mode/chaseModeConfigSlice"

export const fetchEntries = (queryParams) => async (dispatch) => {
  try {
    dispatch(getEntriesStart())
    let entriesResponse = await client.get(
      `/api/v1/entries?${queryString(queryParams)}`
    )
    dispatch(receiveJsonApiData(entriesResponse.data))
  } catch (err) {
    console.log(err)
  } finally {
    dispatch(getEntriesFinished())
  }
}

const queryString = (params) =>
  Object.keys(params)
    .map((key) => key + "=" + params[key])
    .join("&")

export const initializeChaseMode =
  (queryParams) => async (dispatch, getState) => {
    dispatch(fetchChaseModeConfig())
  }

export const fetchChaseModeConfig = () => async (dispatch) => {
  dispatch(getChaseModeConfigStart())
  let response = await client.get("/api/v1/chase_mode_config", {
    headers: {
      Accept: "application/vnd.api+json",
    },
  })
  dispatch(receiveJsonApiData(response.data))
  dispatch(getChaseModeConfigFinished())
}
