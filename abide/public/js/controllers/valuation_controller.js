import { Controller } from "https://unpkg.com/@hotwired/stimulus/dist/stimulus.js"

export default class extends Controller {
    static targets = ["modal", "id", "name", "date", "value", "currentBalance"]

    connect() {
        // Set default date to today
        const today = new Date().toISOString().split('T')[0]
        this.dateTargets.forEach(t => t.value = today)
    }

    open(event) {
        event.preventDefault()

        // Populate form from data attributes
        const button = event.currentTarget
        const id = button.dataset.id
        const name = button.dataset.name
        const balance = button.dataset.balance

        this.idTarget.value = id
        this.nameTarget.textContent = name
        this.currentBalanceTarget.textContent = this.formatCurrency(balance)
        this.valueTarget.value = balance // Default to current value

        this.modalTarget.style.display = "flex"
    }

    close() {
        this.modalTarget.style.display = "none"
    }

    async submit(event) {
        event.preventDefault()

        const id = this.idTarget.value
        const data = {
            date: this.dateTarget.value,
            value: this.valueTarget.value
        }

        try {
            const response = await fetch(`/accounts/${id}/valuation`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(data)
            })

            const result = await response.json()

            if (result.status === 'success') {
                window.location.reload()
            } else {
                alert("Error updating valuation")
            }
        } catch (error) {
            console.error('Error:', error)
            alert("An error occurred")
        }
    }

    formatCurrency(amount) {
        return new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD' }).format(amount)
    }
}
