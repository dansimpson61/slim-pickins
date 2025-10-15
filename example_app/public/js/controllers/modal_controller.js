import { Controller } from "https://cdn.jsdelivr.net/npm/@hotwired/stimulus@3.2.2/+esm"

export default class extends Controller {
  static targets = ["backdrop", "panel"]
  
  open() {
    this.backdropTarget.classList.remove("hidden")
  }
  
  close() {
    this.backdropTarget.classList.add("hidden")
  }
  
  // Close on backdrop click
  closeOnBackdrop(event) {
    if (event.target === this.backdropTarget) {
      this.close()
    }
  }
  
  // Close on escape key
  connect() {
    this.boundHandleKeyup = this.handleKeyup.bind(this)
    document.addEventListener("keyup", this.boundHandleKeyup)
  }
  
  disconnect() {
    document.removeEventListener("keyup", this.boundHandleKeyup)
  }
  
  handleKeyup(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }
}
