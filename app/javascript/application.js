// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("./channels")
require("local-time").start()

//window.Rails = Rails
//window.Turbolinks = Turbolinks

import "./shared/jquery"

import "bootstrap"
import "data-confirm-modal"
import "./controllers"

import "@client-side-validations/client-side-validations" // must be after turbolinks#start()
import "@client-side-validations/simple-form/dist/simple-form.bootstrap4"

import "bootstrap-colorpicker/dist/js/bootstrap-colorpicker.js"

$(document).on("turbolinks:load", () => {
  $('[data-toggle="tooltip"]').tooltip()
  $('[data-toggle="popover"]').popover()
})

$(document).on("turbolinks:before-cache", () => {
  $("#navbarMain").removeClass("show")
  $(".alert").toggle()
})

window.Turbolinks.scroll = {}

document.addEventListener("turbolinks:render", () => {
  const elements = document.querySelectorAll("[data-turbolinks-scroll]")

  elements.forEach(function (element) {
    element.addEventListener("click", () => {
      Turbolinks.scroll["top"] = document.scrollingElement.scrollTop
    })

    element.addEventListener("submit", () => {
      Turbolinks.scroll["top"] = document.scrollingElement.scrollTop
    })
  })

  if (Turbolinks.scroll["top"]) {
    document.scrollingElement.scrollTo(0, Turbolinks.scroll["top"])
  }

  Turbolinks.scroll = {}
})
