// The demo app is a consumer of Slim-Pickins, on the same terms as any other.
// It pulls the library's controllers from /assets (served by AssetMiddleware),
// exactly as abide will, so that a packaging gap breaks the demo too.
import { Application, Controller } from "@hotwired/stimulus"
import { registerSlimPickins } from "/assets/js/slim_pickins.js"

window.Stimulus = Application.start()

// Behaviour that backs a ui_* helper: sp-flash, sp-inline-edit, sp-sortable.
registerSlimPickins(Stimulus)

// --- Demo-only controllers -------------------------------------------------
// No helper emits these; the demo views wire them by hand. They stay here
// until a helper needs them, or until abide needs them a second time.

// Toast notifications. Exposes window.showToast for the demo's onclick buttons.
Stimulus.register("sp-toast-manager", class extends Controller {
    static targets = ["container"]

    connect() {
        window.showToast = this.show.bind(this)
    }

    show(message, type = 'neutral') {
        const toast = document.createElement('div')
        toast.className = `sp-toast sp-toast--${type}`
        toast.textContent = message

        this.containerTarget.appendChild(toast)

        requestAnimationFrame(() => {
            toast.style.opacity = '1'
            toast.style.transform = 'translateY(0)'
        })

        setTimeout(() => {
            toast.style.opacity = '0'
            toast.style.transform = 'translateY(20px)'
            setTimeout(() => toast.remove(), 300)
        }, 3000)
    }
})

// Removes the closest sortable item, then announces it.
Stimulus.register("sp-remove", class extends Controller {
    delete(event) {
        event.preventDefault()

        const item = this.element.closest(".sp-sortable-item")
        if (!item) return

        item.style.transition = "transform 0.2s, opacity 0.2s"
        item.style.transform = "translateX(20px)"
        item.style.opacity = "0"

        setTimeout(() => {
            item.remove()
            if (window.showToast) {
                window.showToast("Item deleted", "danger")
            }
        }, 200)
    }
})

// Renders the docs playground's Slim source on the server as you type.
Stimulus.register("sp-playground", class extends Controller {
    static targets = ["input", "output"]
    static values = { url: String }

    connect() {
        this.render()
    }

    render() {
        clearTimeout(this.timeout)
        this.timeout = setTimeout(() => {
            fetch(this.urlValue, {
                method: "POST",
                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                body: `source=${encodeURIComponent(this.inputTarget.value)}`
            })
                .then(res => res.text())
                .then(html => {
                    this.outputTarget.innerHTML = html
                })
        }, 500)
    }
})
