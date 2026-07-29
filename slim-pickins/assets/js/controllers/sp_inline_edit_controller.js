import { Controller } from "@hotwired/stimulus"

// Drives markup emitted by the `ui_text_field` helper.
// Swaps a display span for an input and sends the new value as JSON,
// keyed by the field's name: { "<name>": "<value>" }.
export default class extends Controller {
    static targets = ["display", "input"]
    static values = { url: String, name: String, method: { type: String, default: "POST" } }

    edit() {
        this.original = this.inputTarget.value
        this.displayTarget.style.display = 'none'
        this.inputTarget.style.display = 'inline-block'
        this.inputTarget.focus()
    }

    save() {
        const value = this.inputTarget.value
        this.close(value)

        fetch(this.urlValue, {
            method: this.methodValue,
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ [this.nameValue]: value })
        })
            .then(response => { if (!response.ok) this.revert() })
            .catch(() => this.revert())
    }

    cancel() {
        this.inputTarget.value = this.displayTarget.textContent
        this.close(this.inputTarget.value)
    }

    // Restores the last known-good value when the server rejects a change.
    revert() {
        if (this.original !== undefined) {
            this.inputTarget.value = this.original
            this.displayTarget.textContent = this.original
        }
    }

    close(value) {
        this.displayTarget.textContent = value
        this.displayTarget.style.display = 'inline-block'
        this.inputTarget.style.display = 'none'
    }
}
