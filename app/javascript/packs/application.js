// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
import TurbolinksAdapter from "vue-turbolinks";
import Vue from "vue/dist/vue.esm";
import App from "../app.vue";
import SimpleVueValidation from 'simple-vue-validator';

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

Vue.use(TurbolinksAdapter);
document.addEventListener("turbolinks:load", () => {
  Vue.use(TurbolinksAdapter);
  Vue.use(SimpleVueValidation);
  if (document.getElementById("app")) {
    new Vue({
      render: h => h(App)
    }).$mount("#app");
  }
});


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)
