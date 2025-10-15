import { Controller } from "https://cdn.jsdelivr.net/npm/@hotwired/stimulus@3.2.2/+esm"

export default class extends Controller {
  static targets = ["tab", "content"]
  
  select(event) {
    const selectedTab = event.currentTarget.dataset.tab
    
    // Update tabs
    this.tabTargets.forEach(tab => {
      if (tab.dataset.tab === selectedTab) {
        tab.classList.add("active")
      } else {
        tab.classList.remove("active")
      }
    })
    
    // Update panels
    const panels = this.element.querySelectorAll(".panel")
    panels.forEach(panel => {
      if (panel.dataset.tab === selectedTab) {
        panel.style.display = "block"
      } else {
        panel.style.display = "none"
      }
    })
  }
  
  connect() {
    // Show first panel by default
    const panels = this.element.querySelectorAll(".panel")
    panels.forEach((panel, index) => {
      panel.style.display = index === 0 ? "block" : "none"
    })
  }
}
