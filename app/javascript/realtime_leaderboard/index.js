import { configureStore } from '@reduxjs/toolkit'
import rootReducers from './reducers'
import React from "react"
import { render } from "react-dom"
import { Provider } from "react-redux"
import { hydrate } from './leaderboard/apiSlice'

import App from './app/App'

const store = configureStore({
  reducer: rootReducers
})

const renderLeaderboard = (element, initialData) => {
  store.dispatch(hydrate(initialData))
  render(
    <Provider store={store}>
      <App />
    </Provider>,
    element
  )
}
export { store, renderLeaderboard }
