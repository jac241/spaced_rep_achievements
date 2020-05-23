import { Controller } from "stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  static targets = [ "span" ]

  connect() {
    this.subscription = consumer.subscriptions.create(
      {
        channel: "LiveLeaderboardsChannel",
        leaderboard: this.data.get("leaderboard"),
      },
      {
        connected: () => {
          // Called when the subscription is ready for use on the server
          console.log("live leaderboard connected: " + this.data.get("leaderboard"))
        },

        disconnected: () => {
          // Called when the subscription has been terminated by the server
        },

        received: (data) => {
          // Called when there's incoming data on the websocket for this channel
          console.log(data)
        }
      }
    )
  }

  disconnect() {
    this.subscription.unsubscribe()
    console.log("live leaderboard unsubscribed: " + this.data.get("leaderboard"))
  }
}
