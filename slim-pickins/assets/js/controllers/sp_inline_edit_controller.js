import { Controller } from "@hotwired/stimulus"

// Drives markup emitted by the `ui_text_field` helper.
// Swaps a display span for an input, and POSTs the new value on save.
export default class extends Controller {
    static targets = ["display", "input"]
    static values = { url: String, name: String }

    edit() {
        this.displayTarget.style.display = 'none'
        this.inputTarget.style.display = 'inline-block'
        this.inputTarget.focus()
    }

    save() {
        const value = this.inputTarget.value
        this.displayTarget.textContent = value
        this.displayTarget.style.display = 'inline-block'
        this.inputTarget.style.display = 'none'

        fetch(this.urlValue, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: `value=${encodeURIComponent(value)}`
        })
    }

    cancel() {
        this.inputTarget.value = this.displayTarget.textContent
        this.displayTarget.style.display = 'inline-block'
        this.inputTarget.style.display = 'none'
    }
}
