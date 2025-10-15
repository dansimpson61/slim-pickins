import { Controller } from "https://cdn.jsdelivr.net/npm/@hotwired/stimulus@3.2.2/+esm"

export default class extends Controller {
  static targets = ["field", "results"]
  static values = {
    url: String,
    target: String,      // CSS selector for results
    debounce: Number,
    initial: Object      // Initial model data
  }
  
  connect() {
    this.timeout = null
    this.currentData = this.initialValue || {}
  }
  
  // Prevent form submission
  prevent(event) {
    event.preventDefault()
  }
  
  // Called on any field input
  changed(event) {
    const field = event.target
    const name = field.name
    const value = this.parseValue(field)
    
    // Update current data
    this.currentData[name] = value
    
    // Debounce the update
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.update()
    }, this.debounceValue)
  }
  
  // Send data to server and update results
  async update() {
    try {
      const response = await fetch(this.urlValue, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        },
        body: JSON.stringify(this.currentData)
      })
      
      if (!response.ok) throw new Error('Update failed')
      
      const html = await response.text()
      
      // Update the target element
      if (this.targetValue) {
        const targetEl = document.querySelector(this.targetValue)
        if (targetEl) {
          targetEl.innerHTML = html
        }
      } else if (this.hasResultsTarget) {
        this.resultsTarget.innerHTML = html
      }
      
    } catch (error) {
      console.error('Reactive form update failed:', error)
      // Optionally show user-friendly error
    }
  }
  
  // Parse field value based on type
  parseValue(field) {
    const type = field.type
    
    if (type === 'number') {
      return parseFloat(field.value) || 0
    } else if (type === 'checkbox') {
      return field.checked
    } else {
      return field.value
    }
  }
}
