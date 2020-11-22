import { Controller } from "stimulus"
import $ from "jquery"

export default class extends Controller {
  connect() {
    $(this.element).on('hidden.bs.modal', function() {
      $(this).empty()
    });
  }
  disconnect() {
    $(this.element).modal('hide')
    $(this.element).empty()
  }
}
