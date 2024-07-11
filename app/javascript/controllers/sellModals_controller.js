import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modals"
export default class extends Controller {
  connect() {}
  close(e) {
    e.preventDefault();
    const sellModal = document.getElementById("sellModal");
    sellModal.innerHTML = "";

    sellModal.removeAttribute("src");
    sellModal.removeAttribute("complete");
  }
}
