// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `rails generate channel` command.

import { createConsumer } from "@rails/actioncable"

const actionCableUrl = process.env.CABLE_URL

if (!window.consumer) {
  window.consumer = createConsumer(actionCableUrl)
}

export default window.consumer
