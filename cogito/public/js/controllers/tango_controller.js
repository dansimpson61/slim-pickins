import { Controller } from "https://unpkg.com/@hotwired/stimulus/dist/stimulus.js"

export default class extends Controller {
  static targets = ["cell", "board", "constraint", "status"]
  
  connect() {
    this.renderConstraints()
  }
  
  renderConstraints() {
    const board = this.boardTarget
    this.constraintTargets.forEach(el => {
      const c1 = JSON.parse(el.dataset.c1)
      const c2 = JSON.parse(el.dataset.c2)
      const type = el.dataset.type
      
      const symbol = type === "same" ? "=" : "×"
      const isHorizontal = c1[0] === c2[0]
      
      const marker = document.createElement('div')
      marker.className = "tango-constraint-marker"
      marker.textContent = symbol
      
      let top, left
      if (isHorizontal) {
        top = c1[0] * 68 + 30 + 12
        left = c1[1] * 68 + 60 + 4 + 12
      } else {
        top = c1[0] * 68 + 60 + 4 + 12
        left = c1[1] * 68 + 30 + 12
      }
      
      marker.style.top = `${top}px`
      marker.style.left = `${left}px`
      board.appendChild(marker)
    })
  }

  toggleCell(event) {
    const el = event.currentTarget
    if (el.classList.contains("hint")) return;
    
    let current = el.dataset.value || "empty"
    if (current === "empty") { current = "sun" } 
    else if (current === "sun") { current = "moon" } 
    else { current = "empty" }
    
    el.dataset.value = current
    const symbolSpan = el.querySelector(".tango-symbol")
    if (current === "sun") { symbolSpan.textContent = "☀️" } 
    else if (current === "moon") { symbolSpan.textContent = "🌙" } 
    else { symbolSpan.textContent = "" }
  }

  async validate() {
    const size = Math.sqrt(this.cellTargets.length)
    const cells = []
    let rowList = []
    
    this.cellTargets.forEach((cell, idx) => {
      rowList.push(cell.dataset.value || "empty")
      if ((idx + 1) % size === 0) {
        cells.push(rowList)
        rowList = []
      }
    })
    
    const constraints = this.constraintTargets.map(el => ({
      type: el.dataset.type,
      cells: [JSON.parse(el.dataset.c1), JSON.parse(el.dataset.c2)]
    }))
    
    const response = await fetch('/tango/validate', {
      method: 'POST',
      body: JSON.stringify({ size, cells, constraints })
    })
    
    const result = await response.json()
    if (result.complete) {
      this.statusTarget.textContent = "✅ Correct! Puzzle complete."
      this.statusTarget.style.color = "green"
    } else if (result.valid) {
      this.statusTarget.textContent = "Looks good so far..."
      this.statusTarget.style.color = "gray"
    } else {
      this.statusTarget.textContent = "❌ There's an error in your logic."
      this.statusTarget.style.color = "red"
    }
  }
}
