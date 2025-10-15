import { Application } from "https://cdn.jsdelivr.net/npm/@hotwired/stimulus@3.2.2/+esm"
import ReactiveFormController from "./controllers/reactive_form_controller.js"

window.Stimulus = Application.start()
Stimulus.register("reactive-form", ReactiveFormController)

console.log("Stimulus loaded with reactive-form controller")
