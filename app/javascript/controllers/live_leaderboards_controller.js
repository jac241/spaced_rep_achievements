import { Controller } from "stimulus"
import consumer from "channels/consumer"
import $ from "jquery"

export default class extends Controller {
  static targets = [ "status" ]

  statuses = {
    connecting: {
      class: "badge-secondary",
      text: "Connecting...",
    },
    live: {
      class: "badge-danger",
      text: "LIVE",
    },
    disconnected: {
      class: "badge-dark",
      text: "Disconnected",
    }
  }

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
          this.showStatus('live')
        },

        disconnected: () => {
          // Called when the subscription has been terminated by the server
          this.showStatus('disconnected')
        },

        received: (data) => {
          console.log('new leaderboard data')

          this.replaceLeaderboardHtml(data.html)
          this.showStatus('live')
        }
      }
    )
  }

  disconnect() {
    console.log("live leaderboard unsubscribed: " + this.leaderboard)
    this.subscription.unsubscribe()
  }

  replaceLeaderboardHtml(html) {
    this.element.innerHTML = html
  }

  showStatus(status_name) {
    this.statusTarget.textContent = this.statuses[status_name].text;

    for (let [status, properties] of Object.entries(this.statuses)) {
      if (this.statusTarget.classList.contains(properties.class)) {
        this.statusTarget.classList.remove(properties.class)
      }
    }

    this.statusTarget.classList.add(this.statuses[status_name].class);
  }
}
