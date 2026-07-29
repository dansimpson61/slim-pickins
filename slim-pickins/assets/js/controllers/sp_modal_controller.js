import { Controller } from "@hotwired/stimulus"

// Drives markup emitted by the `ui_modal` helper.
// Attached to the dialog itself; `ui_modal_trigger` opens it by id.
export default class extends Controller {
    connect() {
        this.onKeydown = event => { if (event.key === "Escape") this.close() }
    }

    disconnect() {
        document.removeEventListener("keydown", this.onKeydown)
    }

    // Runs in the trigger's own scope, so resolve the dialog by id.
    open(event) {
        const id = event?.params?.dialog
        const dialog = id ? document.getElementById(id) : this.element
        if (!dialog) return
        // Remembered so a trigger closes the dialog, not itself.
        this.opened = dialog
        dialog.classList.add("sp-modal--open")
        dialog.setAttribute("aria-hidden", "false")
        document.addEventListener("keydown", this.onKeydown)
    }

    close() {
        const dialog = this.opened || this.element
        dialog.classList.remove("sp-modal--open")
        dialog.setAttribute("aria-hidden", "true")
        this.opened = null
        document.removeEventListener("keydown", this.onKeydown)
    }

    // Clicking the backdrop, but not the panel, dismisses.
    dismiss(event) {
        if (event.target === this.element) this.close()
    }
}
