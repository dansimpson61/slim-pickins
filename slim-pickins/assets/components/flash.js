import { Controller } from "@hotwired/stimulus"

// Drives markup emitted by the `ui_flash` helper.
// Fades the message out, then removes it from the DOM.
export default class extends Controller {
    connect() {
        this.timeout = setTimeout(() => {
            this.element.style.opacity = '0'
            this.removal = setTimeout(() => this.element.remove(), 500)
        }, 3000)
    }

    disconnect() {
        clearTimeout(this.timeout)
        clearTimeout(this.removal)
    }
}
