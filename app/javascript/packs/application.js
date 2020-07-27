// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// require("@rails/ujs").start()
// require("turbolinks").start()
// require("channels")

import "stylesheets/application"

import Vue from 'vue'
document.addEventListener('DOMContentLoaded', () => {
  window.header = new Vue({
    el: "#header",
    data: {
      open: false,
    },
    methods:{
      toggleHeader(e){
        e.preventDefault()
        this.open = !!!this.open
      }
    }
  })
})
