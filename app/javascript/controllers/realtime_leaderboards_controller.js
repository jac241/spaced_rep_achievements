import { Controller } from "stimulus"
import consumer from "channels/consumer"
import $ from "jquery"
import { renderLeaderboard } from 'realtime_leaderboard'
import normalize from 'json-api-normalizer'
import { receiveJsonApiData } from 'realtime_leaderboard/leaderboard/apiSlice'

export default class extends Controller {
  static targets = [ "status" ]

  _subscriptions = []

  connect() {
    if (!this.isTurbolinksPreview) {
      this._initializeTable()
      //const subscription = this._subscribeToLeaderboard()
    }
  }

  _initializeTable() {
    this.store = renderLeaderboard(this.element, this._leaderboardId, this)
  }

  subscribeToLeaderboard() {
    const subscription = this._createSubscription(
      this._leaderboardId,
      this._mostRecentEntryUpdatedAt,
    )

    this._addSubscription(subscription)

    return subscription
  }

  get _leaderboardId() {
    return this.data.get("leaderboard-id")
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

  _createSubscription(leaderboardId, mostRecentEntryUpdatedAt) {
    const controller = this
    return consumer.subscriptions.create(
      {
        channel: "RealtimeLeaderboardsChannel",
        leaderboard_id: leaderboardId,
      },
      {

        connected() {
          // Called when the subscription is ready for use on the server
          console.log("realtime lb connected" + leaderboardId)
          this.requestLatestData()
        },

        disconnected: () => {
        },

        received: (action) => {
          if (action.type === "api/receiveJsonApiData") {
            this.store.dispatch(receiveJsonApiData(action.payload))
          }
        },

        requestLatestData() {
          console.log("requesting")
          this.perform("request_data_since", {
            last_updated: controller._mostRecentEntryUpdatedAt
          })
        },
      }
    )
  }

  _addSubscription(subscription) {
    this._subscriptions.push({
      leaderboardId: this._leaderboardId,
      subscription
    })

    console.log(`Added. New subscription list: ${this._subscriptions}`)
  }

  disconnect() {
    if (!this.isTurbolinksPreview) {
      console.log("disconnected")
      this._clearStore()
      this._unsubscribeFromLeaderboard()
    }
  }

  _clearStore() {
    this.store = null
  }

  _unsubscribeFromLeaderboard() {
    const index = this._subscriptions.findIndex(record => record.leaderboardId === this._leaderboardId)
    const subscriptionRecord = this._subscriptions.splice(index, 1)[0]

    if (subscriptionRecord) {
      subscriptionRecord.subscription.unsubscribe()
      console.log(`Removed. New subscription list: ${this._subscriptions}`)
    }
  }

  get isTurbolinksPreview() {
    return document.documentElement.hasAttribute("data-turbolinks-preview");
  }
}
