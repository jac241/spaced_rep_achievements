import { Controller } from "stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  static targets = [ "span" ]

  connect() {
    this.subscription = consumer.subscriptions.create(
      {
        channel: "LiveLeaderboardsChannel",
        leaderboard: `live_leaderboards:${this.data.get("leaderboard")}`,
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
          console.log(data)
          this.replaceLeaderboardHtml(data.html)
        }
      }
    )
  }

  disconnect() {
    this.subscription.unsubscribe()
    console.log("live leaderboard unsubscribed: " + this.data.get("leaderboard"))
  }

  replaceLeaderboardHtml(html) {
    this.element.innerHTML = html
  }
}
