import { Controller } from "https://unpkg.com/@hotwired/stimulus/dist/stimulus.js"

export default class extends Controller {
    static targets = ["id", "description", "amount", "date", "isTaxable", "taxFields", "fedRate", "stateRate", "fedFeedback", "stateFeedback", "netResult"]

    connect() {
        this.calculate()
    }

    close() {
        document.getElementById("add-withdrawal-modal").classList.remove("active")
    }

    reset() {
        this.idTarget.value = ""
        this.element.querySelector("form").reset()
        this.isTaxableTarget.checked = false
        this.toggleTax()
        this.calculate()
    }

    edit(event) {
        const data = event.currentTarget.dataset

        this.idTarget.value = data.id
        // We need to access fields slightly differently or add targets to inputs.
        // Let's add targets to inputs strictly, or use querySelector for standard names.
        // Since we are inside the controller, using targets is cleaner, but I didn't add targets for desc/date in slim.
        // Let's rely on form elements by name for simplicity if targets aren't exhaustive.
        const form = this.element.querySelector("form")

        form.querySelector('[name="description"]').value = data.description
        this.amountTarget.value = data.amount
        form.querySelector('[name="date"]').value = data.date
        this.isTaxableTarget.checked = (data.taxable === 'true')

        this.toggleTax()
        this.calculate()

        // Open Modal
        document.getElementById("add-withdrawal-modal").classList.add("active")
    }

    async delete(event) {
        if (!confirm("Are you sure?")) return;

        const id = event.currentTarget.dataset.id
        try {
            const response = await fetch(`/movements/${id}`, { method: 'DELETE' })
            if (response.ok) {
                window.location.reload()
            } else {
                alert("Failed to delete.")
            }
        } catch (e) {
            console.error(e)
            alert("Error deleting.")
        }
    }

    toggleTax() {
        if (this.isTaxableTarget.checked) {
            this.taxFieldsTarget.style.display = "block"
        } else {
            this.taxFieldsTarget.style.display = "none"
        }
        this.calculate()
    }

    calculate() {
        const amount = parseFloat(this.amountTarget.value) || 0
        let fedTax = 0
        let stateTax = 0

        if (this.isTaxableTarget.checked) {
            const fedRate = parseFloat(this.fedRateTarget.value) || 0
            const stateRate = parseFloat(this.stateRateTarget.value) || 0

            fedTax = amount * (fedRate / 100)
            stateTax = amount * (stateRate / 100)
        }

        const net = amount - fedTax - stateTax

        // Update UI
        this.fedFeedbackTarget.textContent = `Est. Fed Tax: $${this.formatCurrency(fedTax)}`
        this.stateFeedbackTarget.textContent = `Est. State Tax: $${this.formatCurrency(stateTax)}`
        this.netResultTarget.textContent = `$${this.formatCurrency(net)}`
    }

    formatCurrency(value) {
        return value.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })
    }

    async submit(event) {
        event.preventDefault()

        const formData = new FormData(event.target)
        const data = Object.fromEntries(formData.entries())
        data.is_taxable = this.isTaxableTarget.checked

        const id = this.idTarget.value

        const url = id ? `/movements/${id}` : '/movements'
        const method = id ? 'PUT' : 'POST'

        try {
            const response = await fetch(url, {
                method: method,
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            })

            if (response.ok) {
                window.location.reload()
            } else {
                alert("Something went wrong saving the event.")
            }
        } catch (e) {
            console.error(e)
            alert("Error submitting form.")
        }
    }
}
