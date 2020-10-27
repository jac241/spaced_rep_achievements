import { Controller } from "stimulus"
import $ from "jquery"

export default class extends Controller {
  static targets = [ "dismissButton" ]
  toastDelayMs = 20*1000
  toastKey = 'groupToastDismissed'

  connect() {
    this.showToastIfAppropriate()
    this.setUpDismissButtonListener()
  }

  showToastIfAppropriate() {
    if (!(localStorage.getItem(this.toastKey) === 'true')) {
      $(this.element).toast({ delay: this.toastDelayMs }).toast('show')
    } else {
      $(this.element).hide()
    }
  }

  setUpDismissButtonListener() {
    $(this.dismissButtonTarget).click(() => {
      localStorage.setItem(this.toastKey, 'true')
    })
  }
}
