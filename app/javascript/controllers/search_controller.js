import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "hiddenInput", "listings", "listing", "searchBtn"]

  connect() {
    this.inputTarget.addEventListener('input', this.filterListings.bind(this))
    this.inputTarget.addEventListener('focus', this.handleFocus.bind(this))
    this.inputTarget.addEventListener('blur', this.handleBlur.bind(this))
    this.addClickListenersToListings()
    this.filterListings()
    console.log("Stock controller connected")
  }

  filterListings() {
    const searchText = this.inputTarget.value.trim().toLowerCase()
    this.listingTargets.forEach(listing => {
      const text = listing.textContent.trim().toLowerCase()
      if (text.includes(searchText)) {
        listing.style.display = "block"
      } else {
        listing.style.display = "none"
      }
    })
  }

  addClickListenersToListings() {
    this.listingTargets.forEach(listing => {
      listing.addEventListener('click', this.setInputValue.bind(this))
    })
  }

  setInputValue(event) {
    const [symbol, ...nameParts] = event.target.textContent.trim().split(" ")
    const name = nameParts.join(" ")
    this.inputTarget.value = `${symbol} ${name}`
    this.hiddenInputTarget.value = symbol
    this.filterListings()
    this.inputTarget.focus()
  }

  showListings() {
    this.listingsTarget.style.display = "block"
  }

  hideListings() {
      this.listingsTarget.style.display = "none"
  }

  handleFocus() {
    this.searchBtnTarget.style.display = "none"
    this.inputTarget.classList.remove("rounded-3xl")
    this.inputTarget.classList.add("rounded-t-3xl")
    this.showListings()
  }

  handleBlur() {
    setTimeout(() => {
      this.searchBtnTarget.style.display = "block"
      this.inputTarget.classList.add("rounded-3xl")
      this.inputTarget.classList.remove("rounded-t-3xl")
      this.hideListings()
    }, 200)
  }
}
