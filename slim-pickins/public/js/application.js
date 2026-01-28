import { Application, Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

window.Stimulus = Application.start()

// Register controllers inline for the demo for simplicity
// In a real gem, these would be in separate files

// 1. Flash Controller (Auto-dismiss)
Stimulus.register("sp-flash", class extends Controller {
    connect() {
        setTimeout(() => {
            this.element.style.opacity = '0';
            setTimeout(() => this.element.remove(), 500);
        }, 3000);
    }
})

// 2. Inline Edit Controller
Stimulus.register("sp-inline-edit", class extends Controller {
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

        // Post to server
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
})

// 3. Sortable Controller
Stimulus.register("sp-sortable", class extends Controller {
    static values = { url: String, animation: Number }

    connect() {
        this.sortable = new Sortable(this.element, {
            animation: this.animationValue || 150,
            onEnd: this.onEnd.bind(this)
        })
    }

    onEnd(event) {
        const ids = Array.from(this.element.children).map(el => el.dataset.id)
        console.log("New order:", ids)

        fetch(this.urlValue, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ ids: ids })
        })
    }
})

// 4. Toast Notification Manager
Stimulus.register("sp-toast-manager", class extends Controller {
    static targets = ["container"]

    connect() {
        window.showToast = this.show.bind(this)
    }

    show(message, type = 'neutral') {
        const toast = document.createElement('div')
        toast.className = `sp-toast sp-toast--${type}`
        toast.textContent = message

        // Add to container
        this.containerTarget.appendChild(toast)

        // Trigger animation
        requestAnimationFrame(() => {
            toast.style.opacity = '1'
            toast.style.transform = 'translateY(0)'
        })

        // Dismiss after 3s
        setTimeout(() => {
            toast.style.opacity = '0'
            toast.style.transform = 'translateY(20px)'
        }, 3000)
    }
})

// 5. Details/Summary Animation Controller
Stimulus.register("sp-details", class extends Controller {
    toggle(event) {
        event.preventDefault()
        this.element.open ? this.close() : this.open()
    }

    open() {
        this.element.open = true
        // Wait for two frames to ensure the element is visible and layout is calculated
        requestAnimationFrame(() => {
            requestAnimationFrame(() => {
                this.element.classList.add("is-open")
            })
        })
    }

    close() {
        this.element.classList.remove("is-open")
        // Wait for CSS transition to finish before removing attribute
        setTimeout(() => {
            if (!this.element.classList.contains("is-open")) {
                this.element.open = false
            }
        }, 300) // Match CSS transition duration
    }
})
