import { Controller } from "stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  static targets = [ "span" ]

  connect() {
    this.spanTarget.textContent = "Syncing..."
    let syncController = this

    consumer.subscriptions.create("SyncChannel", {
      connected() {
        // Called when the subscription is ready for use on the server
        console.log("sync connected")
        this.startSync()
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        // Called when there's incoming data on the websocket for this channel
        console.log(data)
      },

      startSync() {
        this.perform("start_sync")
      }
    })
  }
}
