import React from "react"
import { render, unmountComponentAtNode } from "react-dom"
import { configureStore } from '@reduxjs/toolkit'
import { Provider } from "react-redux"
import ChaseMode from './ChaseMode'

import rootReducers from './reducers'

const renderChaseMode = () => {
  let dataElement = document.querySelector("#chase_mode_root")
  let element = document.querySelector("#chase_mode_react_node")

  if (element) {
    if (unmountComponentAtNode(element)) {
      console.log("Unmounted existing chase mode preact component")
    }
  } else {
    element = createChaseModeDOMNode()
    document.body.appendChild(element)
  }

  console.log("rendering chase mode")

  const middlewares = []
  if (process.env.NODE_ENV === `development`) {
    const { logger } = require(`redux-logger`);

    middlewares.push(logger);
  }

  const store = configureStore({
    reducer: rootReducers,
    middleware: (getDefaultMiddleware) => (
      getDefaultMiddleware({serializableCheck: false}).concat(middlewares)
    )
  })

  render(
    <Provider store={store}>
      <ChaseMode
        userId={dataElement.dataset.currentUserId}
        reifiedLeaderboardId={dataElement.dataset.reifiedLeaderboardId}
      />
    </Provider>,
    element
  )
}

const createChaseModeDOMNode = () => {
  let element = document.createElement("div");
  element.setAttribute("id", "chase_mode_react_node")
  return element
}

export { renderChaseMode }
