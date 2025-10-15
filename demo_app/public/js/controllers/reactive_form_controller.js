import { Controller } from "https://cdn.jsdelivr.net/npm/@hotwired/stimulus@3.2.2/+esm"

export default class extends Controller {
  static targets = ["field", "results"]
  static values = {
    url: String,
    target: String,
    debounce: Number,
    initial: Object
  }
  
  connect() {
    this.timeout = null
    this.currentData = this.initialValue || {}
    console.log("✅ Reactive form connected!")
    console.log("📍 URL:", this.urlValue)
    console.log("🎯 Target:", this.targetValue)
    console.log("⏱️  Debounce:", this.debounceValue + "ms")
    console.log("📊 Initial data:", this.currentData)
  }
  
  prevent(event) {
    event.preventDefault()
    console.log("🚫 Form submission prevented")
  }
  
  changed(event) {
    const field = event.target
    const name = field.name
    const value = this.parseValue(field)
    
    console.log("📝 Field changed:", name, "=", value)
    
    this.currentData[name] = value
    
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      console.log("⏰ Debounce complete, updating...")
      this.update()
    }, this.debounceValue)
  }
  
  async update() {
    console.log("🚀 Sending update to:", this.urlValue)
    console.log("📤 Data:", this.currentData)
    
    try {
      const response = await fetch(this.urlValue, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        },
        body: JSON.stringify(this.currentData)
      })
      
      console.log("📥 Response status:", response.status)
      
      if (!response.ok) {
        throw new Error(`Update failed with status ${response.status}`)
      }
      
      const html = await response.text()
      console.log("✅ Got HTML response, updating DOM")
      
      if (this.targetValue) {
        const targetEl = document.querySelector(this.targetValue)
        if (targetEl) {
          targetEl.innerHTML = html
          console.log("✅ Updated target:", this.targetValue)
        } else {
          console.error("❌ Target element not found:", this.targetValue)
        }
      } else if (this.hasResultsTarget) {
        this.resultsTarget.innerHTML = html
        console.log("✅ Updated results target")
      }
      
    } catch (error) {
      console.error('❌ Reactive form update failed:', error)
    }
  }
  
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
