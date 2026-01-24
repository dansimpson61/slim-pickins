import { Controller } from "https://unpkg.com/@hotwired/stimulus/dist/stimulus.js"

export default class extends Controller {
    static targets = ["name", "type"]

    async submit(event) {
        event.preventDefault()

        const data = {
            name: this.nameTarget.value,
            type: this.typeTarget.value
        }

        try {
            const response = await fetch('/accounts', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            })

            if (response.ok) {
                window.location.reload()
            } else {
                alert("Error creating account")
            }
        } catch (e) {
            alert("An error occurred")
        }
    }
}
