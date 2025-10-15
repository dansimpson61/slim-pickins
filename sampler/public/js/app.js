// Slim-Pickins Sampler JavaScript

import { Application } from "https://cdn.jsdelivr.net/npm/@hotwired/stimulus@3.2.2/+esm"

// Import controllers
import ModalController from "./controllers/modal_controller.js"
import DropdownController from "./controllers/dropdown_controller.js"
import SearchController from "./controllers/search_controller.js"
import TabsController from "./controllers/tabs_controller.js"

// Start Stimulus
const application = Application.start()

// Register controllers
application.register("modal", ModalController)
application.register("dropdown", DropdownController)
application.register("search", SearchController)
application.register("tabs", TabsController)

console.log("🍞 Sampler loaded")
