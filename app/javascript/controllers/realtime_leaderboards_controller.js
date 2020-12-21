import { Controller } from "stimulus"
import consumer from "channels/consumer"
import $ from "jquery"
import { renderLeaderboard } from 'realtime_leaderboard'
import normalize from 'json-api-normalizer'
import { receiveJsonApiData } from 'realtime_leaderboard/leaderboard/apiSlice'

export default class extends Controller {
  static targets = [ "status" ]

  statuses = {
    connecting: {
      class: "badge-secondary",
      text: "Connecting...",
    },
    live: {
      class: "badge-danger",
      text: "Connected",
    },
    disconnected: {
      class: "badge-dark",
      text: "Disconnected",
    }
  }

  _subscriptions = []

  connect() {
    if (!this.isTurbolinksPreview) {
      this._initializeTable()
      this._subscribeToLeaderboard()
    }
  }

  _initializeTable() {
    const initialData = JSON.parse(this.data.get("initial-data"))
    console.log(normalize(initialData))
    this.store = renderLeaderboard(this.element, initialData)
  }

  _subscribeToLeaderboard() {
    this._addSubscription(
      this._createSubscription(
        this._leaderboard,
        this._mostRecentEntryUpdatedAt,
      )
    )
  }

  get _leaderboard() {
    return this.data.get("leaderboard")
  }

  get _mostRecentEntryUpdatedAt() {
    const entries = this.store.getState().entries
    let max = new Date('1995-12-17T03:24:00')
    entries.ids.forEach((id) => {
      const updatedAt = new Date(entries.entities[id].attributes.updatedAt)
      if (updatedAt > max) {
        max = updatedAt
      }
    })

    return max
  }

  _createSubscription(leaderboard, mostRecentEntryUpdatedAt) {
    console.log(`Most recent updated at: ${mostRecentEntryUpdatedAt}`)
    return consumer.subscriptions.create(
      {
        channel: "RealtimeLeaderboardsChannel",
        leaderboard: `realtime_leaderboards:${leaderboard}`,
        last_updated: mostRecentEntryUpdatedAt,
      },
      {
        connected: () => {
          // Called when the subscription is ready for use on the server
          console.log("realtime lb connected" + leaderboard)
        },

        disconnected: () => {
        },

        received: (action) => {
          console.log("received realtime")
          console.log(action)
          if (action.type === "api/receiveJsonApiData") {
            this.store.dispatch(receiveJsonApiData(action.payload))
          }
        },
      }
    )
  }

  _addSubscription(subscription) {
    this._subscriptions.push({
      leaderboard: this._leaderboard,
      subscription
    })

    console.log(`Added. New subscription list: ${this._subscriptions}`)
  }

  disconnect() {
    console.log("disconnected")
    this._clearStore()
    this._unsubscribeFromLeaderboard()
  }

  _clearStore() {
    this.store = null
  }

  _unsubscribeFromLeaderboard() {
    const index = this._subscriptions.findIndex(record => record.leaderboard === this._leaderboard)
    const subscriptionRecord = this._subscriptions.splice(index, 1)[0]

    subscriptionRecord.subscription.unsubscribe()
    console.log(`Removed. New subscription list: ${this._subscriptions}`)
  }
}
