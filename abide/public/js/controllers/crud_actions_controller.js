import { Controller } from "https://unpkg.com/@hotwired/stimulus/dist/stimulus.js"

export default class extends Controller {
    static values = {
        url: String
    }

    async delete(event) {
        if (!confirm("Are you sure? This action cannot be undone.")) return

        try {
            const response = await fetch(this.urlValue, { method: 'DELETE' })
            if (response.ok) {
                this.element.remove()
            } else {
                const json = await response.json()
                alert(json.message || "Delete failed")
            }
        } catch (e) {
            alert("An error occurred")
        }
    }

    async archive(event) {
        if (!confirm("Archive this account?")) return
        this.putAction('archive')
    }

    async restore(event) {
        this.putAction('restore')
    }

    async putAction(action) {
        try {
            const response = await fetch(`${this.urlValue}/${action}`, { method: 'PUT' })
            if (response.ok) {
                this.element.remove() // Move out of view
            } else {
                alert("Action failed")
            }
        } catch (e) {
            alert("An error occurred")
        }
    }
}
