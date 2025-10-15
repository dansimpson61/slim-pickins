import { Controller } from "https://cdn.jsdelivr.net/npm/@hotwired/stimulus@3.2.2/+esm"

export default class extends Controller {
  static targets = ["menu"]
  
  toggle() {
    this.menuTarget.classList.toggle("hidden")
  }
  
  // Close when clicking outside
  connect() {
    this.boundHandleClickOutside = this.handleClickOutside.bind(this)
    document.addEventListener("click", this.boundHandleClickOutside)
  }
  
  disconnect() {
    document.removeEventListener("click", this.boundHandleClickOutside)
  }
  
  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }
}
