import { Controller } from "stimulus"
import consumer from "channels/consumer"
import $ from "jquery"
import { renderLeaderboard } from 'realtime_leaderboard'
import normalize from 'json-api-normalizer'
import { receiveJsonApiData } from 'realtime_leaderboard/leaderboard/apiSlice'
import {
  getCachedEntriesStart,
  getCachedEntriesSuccess
} from 'realtime_leaderboard/leaderboard/entriesSlice'
import { unmountComponentAtNode } from 'react-dom'

export default class extends Controller {
  static targets = [ "status" ]

  _subscriptions = []

  INITIAL_CABLE_STATUS = 'lb_not_yet_requested'

  connect() {
    if (!this.isTurbolinksPreview) {
      this._initializeTable()
      this._cable_status = this.INITIAL_CABLE_STATUS
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
          if (controller._cable_status === 'lb_not_yet_requested'){
            controller.onCachedEntriesRequested()
            this.requestCachedData()
          }
          else {
            this.requestLatestData()
          }
        },

        disconnected() {
        },

        received(action) {
          if (
            controller._cable_status === 'cached_lb_requested' &&
            action.payload.meta && action.payload.meta.from_cache
          ) {
            controller.onCachedEntriesReceived(action)
            this.requestLatestData()
          } else if (controller._cable_status === 'cached_lb_received') {
            if (action.type === "api/receiveJsonApiData") {
              controller.store.dispatch(receiveJsonApiData(action.payload))
            }
          }
        },

        requestLatestData() {
          console.log("requesting", controller._mostRecentEntryUpdatedAt)
          this.perform("request_data_since", {
            last_updated: controller._mostRecentEntryUpdatedAt
          })
        },

        requestCachedData() {
          console.log("requesting", controller._mostRecentEntryUpdatedAt)
          this.perform("request_data_since", {
            should_use_cache: true
          })
        }
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
      this._cable_status = this.INITIAL_CABLE_STATUS
      console.log('unmounted?:', unmountComponentAtNode(this.element))
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

  onCachedEntriesRequested() {
    this.store.dispatch(getCachedEntriesStart())
    this._cable_status = 'cached_lb_requested'
  }

  onCachedEntriesReceived(serverAction) {
    this.store.dispatch(receiveJsonApiData(serverAction.payload))
    this._cable_status = 'cached_lb_received'
    this.store.dispatch(getCachedEntriesSuccess())
  }
}
