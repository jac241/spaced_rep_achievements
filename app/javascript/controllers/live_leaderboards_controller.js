import { Controller } from "stimulus"
import consumer from "channels/consumer"
import $ from "jquery"

export default class extends Controller {
  static targets = [ "status" ]

  initialize() {
    this.leaderboard = this.data.get("leaderboard")
  }

  connect() {
    this.subscription = consumer.subscriptions.create(
      {
        channel: "LiveLeaderboardsChannel",
        leaderboard: `live_leaderboards:${this.leaderboard}`,
      },
      {
        connected: () => {
          // Called when the subscription is ready for use on the server
          console.log("live leaderboard connected: " + this.data.get("leaderboard"))
          this.showLiveStatus()
        },

        disconnected: () => {
          // Called when the subscription has been terminated by the server
          this.hideLiveStatus()
        },

        received: (data) => {
          console.log(data)
          this.replaceLeaderboardHtml(data.html)
          this.showLiveStatus()
        }
      }
    )
  }

  disconnect() {
    this.subscription.unsubscribe()
    console.log("live leaderboard unsubscribed: " + this.leaderboard)
  }

  replaceLeaderboardHtml(html) {
    this.element.innerHTML = html
  }

  showLiveStatus() {
    $(this.statusTarget).show()
  }

  hideLiveStatus() {
    $(this.statusTarget).hide()
  }
}
