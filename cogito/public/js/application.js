import { Application } from "https://unpkg.com/@hotwired/stimulus/dist/stimulus.js"

const application = Application.start()

import TangoController from "./controllers/tango_controller.js"
import QueensController from "./controllers/queens_controller.js"

application.register("tango", TangoController)
application.register("queens", QueensController)

window.Stimulus = application
