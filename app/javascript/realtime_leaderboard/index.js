// Or if you just want the devtools bridge (~240B) without other
// debug code (useful for production sites)
import "preact/devtools";

import { configureStore } from '@reduxjs/toolkit'
import rootReducers from './reducers'
import React from "react"
import { render } from "react-dom"
import { Provider } from "react-redux"
import { persistStore, persistReducer } from 'redux-persist'
import autoMergeLevel2 from 'redux-persist/lib/stateReconciler/autoMergeLevel2'
import { PersistGate } from 'redux-persist/lib/integration/react'
import localForage from 'localforage'


import App from './app/App'
import { receiveJsonApiData } from './leaderboard/apiSlice'

const renderLeaderboard = (element, leaderboardKey, controller) => {
  const persistConfig = {
    key: `realtimeLeaderboard:${leaderboardKey}`,
    storage: localForage,
    stateReconciler: autoMergeLevel2
  }
  const middlewares = []
  if (process.env.NODE_ENV === `development`) {
    const { logger } = require(`redux-logger`);

    middlewares.push(logger);
  }


  const pReducer = persistReducer(persistConfig, rootReducers)
  const store = configureStore({
    reducer: pReducer,
    middleware: (getDefaultMiddleware) => getDefaultMiddleware({serializableCheck: false}).concat(middlewares),
  })
  const persistor = persistStore(store)

  render(
    <Provider store={store}>
      <PersistGate loading={null} persistor={persistor}>
        <App controller={controller}/>
      </PersistGate>
    </Provider>,
    element
  )

  return store
}
export { renderLeaderboard }
