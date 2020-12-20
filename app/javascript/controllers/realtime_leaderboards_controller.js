import { Controller } from "stimulus"
import consumer from "channels/consumer"
import $ from "jquery"
import { renderLeaderboard } from 'realtime_leaderboard'
import normalize from 'json-api-normalizer'

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

  connect() {
    if (!this.isTurbolinksPreview) {
      //this.subscribeToLeaderboard()
      //console.log('worked')
    }
    const initialData = JSON.parse(this.data.get("data"))
    console.log(normalize(initialData))
    this.store = renderLeaderboard(this.element, normalize(initialData))
  }

  disconnect() {
    console.log("disconnected")
    this.store = null
  }

  //subscribeToLeaderboard() {
    //this.leaderboard = this.data.get("leaderboard")

    //if (this.leaderboard === localStorage.getItem('lastLeaderboard')) {
      //// Previous subscription is getting cancelled, need to wait so it doesn't
      //// cancel ours. Brittle race condition but I don't see another way right
      //// now...
      //console.log('rt Waiting to connect!')
      //setTimeout(() => {
        //this.subscription = this.createSubscription(this.leaderboard)
        //localStorage.setItem('lastLeaderboard', this.leaderboard)
      //}, 1500)
    //} else {
      //this.subscription = this.createSubscription(this.leaderboard)
      //localStorage.setItem('lastLeaderboard', this.leaderboard)
    //}
  //}

  //createSubscription(leaderboard) {
    //return consumer.subscriptions.create(
      //{
        //channel: "RealtimeLeaderboardsChannel",
        //leaderboard: leaderboard,
      //},
      //{
        //connected: () => {
          //// Called when the subscription is ready for use on the server
          //console.log("realtime lb connected" + leaderboard)
        //},

        //disconnected: () => {
        //},

        //received: (data) => {
          //console.log(`realtime: ${data}`)
        //},

      //}
    //)
  //}
}
