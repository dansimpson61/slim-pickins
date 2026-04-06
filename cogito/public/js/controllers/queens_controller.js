import { Controller } from "https://unpkg.com/@hotwired/stimulus/dist/stimulus.js"

export default class extends Controller {
  static targets = ["cell", "status"]

  connect() {
    console.log("Queens controller connected!")
  }

  toggleCell(event) {
    const el = event.currentTarget
    
    // In queens app, we can either place an x or a crown. 
    // Basic interaction: Empty -> X -> Crown -> Empty
    let current = el.dataset.value || "empty"
    
    if (current === "empty") {
      current = "x"
    } else if (current === "x") {
      current = "crown"
    } else {
      current = "empty"
    }
    
    el.dataset.value = current
    const symbolSpan = el.querySelector(".queens-symbol")
    
    if (current === "x") {
      symbolSpan.textContent = "✖"
      symbolSpan.className = "queens-symbol mark-x"
    } else if (current === "crown") {
      symbolSpan.textContent = "♛"
      symbolSpan.className = "queens-symbol mark-crown"
    } else {
      symbolSpan.textContent = ""
      symbolSpan.className = "queens-symbol"
    }
  }

  async validate() {
    const size = Math.sqrt(this.cellTargets.length)
    const cells = []
    let rowList = []
    
    this.cellTargets.forEach((cell, idx) => {
      rowList.push({
        region_id: parseInt(cell.dataset.region),
        has_queen: (cell.dataset.value === "crown")
      })
      if ((idx + 1) % size === 0) {
        cells.push(rowList)
        rowList = []
      }
    })
    
    const response = await fetch('/queens/validate', {
      method: 'POST',
      body: JSON.stringify({ size, cells })
    })
    
    const result = await response.json()
    if (result.complete) {
      this.statusTarget.textContent = "✅ Correct! All crowns placed."
      this.statusTarget.style.color = "green"
    } else if (result.valid) {
      this.statusTarget.textContent = "Looks good so far..."
      this.statusTarget.style.color = "gray"
    } else {
      this.statusTarget.textContent = "❌ Crowns are touching or clustered!"
      this.statusTarget.style.color = "red"
    }
  }
}
