// Or if you just want the devtools bridge (~240B) without other
// debug code (useful for production sites)
import "preact/devtools";

import { configureStore } from '@reduxjs/toolkit'
import rootReducers from './reducers'
import React from "react"
import { render } from "react-dom"
import { Provider } from "react-redux"

import App from './app/App'
import { receiveJsonApiData } from './leaderboard/apiSlice'

const renderLeaderboard = (element, leaderboardKey, controller) => {
  const middlewares = []
  if (process.env.NODE_ENV === `development`) {
    const { logger } = require(`redux-logger`);

    middlewares.push(logger);
  }

  const store = configureStore({
    reducer: rootReducers,
    middleware: (getDefaultMiddleware) => getDefaultMiddleware({serializableCheck: false}).concat(middlewares),
  })

  render(
    <Provider store={store}>
      <App controller={controller}/>
    </Provider>,
    element
  )

  return store
}

export { renderLeaderboard }
