import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

// Drives markup emitted by the `ui_sortable_list` helper.
// POSTs the new order (an array of `data-id`s) whenever a drag finishes.
export default class extends Controller {
    static values = { url: String, animation: Number }

    connect() {
        this.sortable = new Sortable(this.element, {
            animation: this.animationValue || 150,
            onEnd: this.onEnd.bind(this)
        })
    }

    disconnect() {
        this.sortable?.destroy()
        this.sortable = null
    }

    onEnd() {
        const ids = Array.from(this.element.children).map(el => el.dataset.id)

        fetch(this.urlValue, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ ids: ids })
        })
    }
}
