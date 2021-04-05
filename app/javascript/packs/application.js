// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import { Turbo } from "@hotwired/turbo-rails";
window.Turbo = Turbo;

require("@rails/ujs").start();
require("@rails/activestorage").start();
require("channels");

import "stylesheets/application";

document.addEventListener("turbo:load", () => {
  const table = document.getElementById("request-table");

  if (table) {
    table.addEventListener("click", (e) => {
      const id = e.target.dataset.id;
      if (id) {
        e.preventDefault();
        const row = document.querySelector(`tr[data-id=request-${id}]`);
        row.classList.toggle("hidden");
      }
    });
  }
});
