// toggle_panel_controller.js
// Stimulus controller for toggle panel system
// 
// Handles:
// - Toggle open/closed state
// - localStorage persistence
// - ARIA attribute updates
// - Keyboard accessibility

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]
  static values = { 
    position: String 
  }
  
  connect() {
    // Restore saved state from localStorage
    this.restoreState()
    
    // Add keyboard support
    this.addKeyboardSupport()
  }
  
  toggle(event) {
    // Prevent default if it's a button
    if (event) {
      event.preventDefault()
      event.stopPropagation()
    }
    
    // Toggle collapsed class
    const wasCollapsed = this.element.classList.contains('collapsed')
    this.element.classList.toggle('collapsed')
    
    // Update ARIA
    this.updateAria(!wasCollapsed)
    
    // Save state
    this.saveState()
    
    // Dispatch custom event for other components to listen to
    this.dispatchToggleEvent(!wasCollapsed)
  }
  
  expand() {
    if (this.element.classList.contains('collapsed')) {
      this.toggle()
    }
  }
  
  collapse() {
    if (!this.element.classList.contains('collapsed')) {
      this.toggle()
    }
  }
  
  updateAria(collapsed) {
    const header = this.element.querySelector('.panel-header')
    if (header) {
      header.setAttribute('aria-expanded', collapsed ? 'false' : 'true')
    }
  }
  
  saveState() {
    const collapsed = this.element.classList.contains('collapsed')
    const key = this.storageKey()
    
    try {
      localStorage.setItem(key, collapsed ? 'collapsed' : 'expanded')
    } catch (e) {
      // localStorage might be unavailable (private mode, etc.)
      console.warn('Could not save toggle panel state:', e)
    }
  }
  
  restoreState() {
    const key = this.storageKey()
    
    try {
      const state = localStorage.getItem(key)
      
      if (state === 'collapsed') {
        this.element.classList.add('collapsed')
        this.updateAria(true)
      } else if (state === 'expanded') {
        this.element.classList.remove('collapsed')
        this.updateAria(false)
      }
      // If no saved state, leave as-is (default expanded)
    } catch (e) {
      // localStorage might be unavailable
      console.warn('Could not restore toggle panel state:', e)
    }
  }
  
  addKeyboardSupport() {
    const header = this.element.querySelector('.panel-header')
    
    if (header) {
      header.addEventListener('keydown', (event) => {
        // Space or Enter toggles
        if (event.key === ' ' || event.key === 'Enter') {
          event.preventDefault()
          this.toggle()
        }
        
        // Escape closes panel (optional feature)
        if (event.key === 'Escape') {
          this.collapse()
        }
      })
    }
  }
  
  storageKey() {
    // Use panel ID as storage key
    return `toggle-panel-${this.element.id}`
  }
  
  dispatchToggleEvent(collapsed) {
    // Dispatch custom event for other components
    const event = new CustomEvent('toggle-panel:change', {
      detail: {
        id: this.element.id,
        collapsed: collapsed,
        position: this.positionValue
      },
      bubbles: true
    })
    
    this.element.dispatchEvent(event)
  }
}
