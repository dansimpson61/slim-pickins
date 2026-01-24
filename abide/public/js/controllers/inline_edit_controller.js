import { Controller } from "https://unpkg.com/@hotwired/stimulus/dist/stimulus.js"

export default class extends Controller {
    static targets = ["display", "input"]
    static values = {
        url: String,
        param: String
    }

    edit(event) {
        event.preventDefault()
        this.displayTarget.classList.add("hidden")
        this.inputTarget.classList.remove("hidden")
        this.inputTarget.focus()
    }

    save() {
        const value = this.inputTarget.value
        const data = {}
        data[this.paramValue] = value

        fetch(this.urlValue, {
            method: 'PUT',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(data)
        })
            .then(response => {
                if (response.ok) {
                    this.displayTarget.textContent = value
                    this.reset()
                } else {
                    alert("Failed to save changes")
                    this.reset()
                }
            })
            .catch(error => {
                console.error(error)
                alert("An error occurred")
                this.reset()
            })
    }

    cancel(event) {
        if (event.type === 'keydown' && event.key !== 'Escape') return
        this.reset()
    }

    reset() {
        this.displayTarget.classList.remove("hidden")
        this.inputTarget.classList.add("hidden")
        this.inputTarget.value = this.displayTarget.textContent
    }
}
