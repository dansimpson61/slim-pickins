import { Controller } from "https://unpkg.com/@hotwired/stimulus/dist/stimulus.js"

export default class extends Controller {
    open() {
        const modal = document.getElementById("add-withdrawal-modal")
        if (modal) {
            modal.classList.add("active")
        }
    }
}
