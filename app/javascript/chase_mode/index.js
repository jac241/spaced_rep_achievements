import React from "react"
import { render } from "react-dom"
import { configureStore } from '@reduxjs/toolkit'
import { Provider } from "react-redux"
import ChaseMode from './ChaseMode'

import rootReducers from './reducers'

const renderChaseMode = () => {
  let element = document.querySelector("#chase_mode_root")
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
      <ChaseMode
        userId={element.dataset.currentUserId}
        reifiedLeaderboardId={element.dataset.reifiedLeaderboardId}
      />
    </Provider>,
    element
  )
}

export { renderChaseMode }
