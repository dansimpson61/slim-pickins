// Slim-Pickins Example App JavaScript

import { Application } from "https://cdn.jsdelivr.net/npm/@hotwired/stimulus@3.2.2/+esm"

// Import controllers
import ModalController from "./controllers/modal_controller.js"
import TodoController from "./controllers/todo_controller.js"
import SearchController from "./controllers/search_controller.js"

// Start Stimulus
const application = Application.start()

// Register controllers
application.register("modal", ModalController)
application.register("todo", TodoController)
application.register("search", SearchController)

console.log("🍞 Slim-Pickins loaded")
