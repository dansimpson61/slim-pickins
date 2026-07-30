import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["form", "id", "description", "amount", "date", "isTaxable", "taxFields", "fedRate", "stateRate", "fedFeedback", "stateFeedback", "netResult"]

    connect() {
        this.calculate()
    }

    close() {
        document.getElementById("add-withdrawal-modal").classList.remove("sp-modal--open")
    }

    reset() {
        this.idTarget.value = ""
        this.formTarget.reset()
        this.isTaxableTarget.checked = false
        this.toggleTax()
        this.calculate()
    }

    edit(event) {
        const data = event.currentTarget.dataset

        // Targets, not querySelector("form"): this controller's scope is the
        // whole page, whose first form is the portfolio selector, not this one.
        this.idTarget.value = data.id
        this.descriptionTarget.value = data.description
        this.amountTarget.value = data.amount
        this.dateTarget.value = data.date
        this.isTaxableTarget.checked = (data.taxable === 'true')

        this.toggleTax()
        this.calculate()

        // Open Modal
        document.getElementById("add-withdrawal-modal").classList.add("sp-modal--open")
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
