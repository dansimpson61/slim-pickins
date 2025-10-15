import { Controller } from "https://cdn.jsdelivr.net/npm/@hotwired/stimulus@3.2.2/+esm"

export default class extends Controller {
  static targets = ["results"]
  static values = { url: String }
  
  async query(event) {
    const searchTerm = event.target.value
    const url = `${this.urlValue}?q=${encodeURIComponent(searchTerm)}`
    
    try {
      const response = await fetch(url)
      const html = await response.text()
      
      // Find the todo-list element in the page and replace it
      const todoList = document.querySelector('.todo-list')
      if (todoList) {
        todoList.outerHTML = html
      }
    } catch (error) {
      console.error("Search failed:", error)
    }
  }
}
