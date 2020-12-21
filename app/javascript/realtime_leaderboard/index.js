import { configureStore } from '@reduxjs/toolkit'
import rootReducers from './reducers'
import React from "react"
import { render } from "react-dom"
import { Provider } from "react-redux"
import { receiveJsonApiData } from './leaderboard/apiSlice'

import App from './app/App'

const renderLeaderboard = (element, initialData) => {
  const store = configureStore({
    reducer: rootReducers
  })

  store.dispatch(receiveJsonApiData(initialData))
  render(
    <Provider store={store}>
      <App />
    </Provider>,
    element
  )

  return store
}
export { renderLeaderboard }
