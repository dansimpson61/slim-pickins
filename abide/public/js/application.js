import { Application } from "https://unpkg.com/@hotwired/stimulus/dist/stimulus.js"
import WithdrawalFormController from "./controllers/withdrawal_form_controller.js"
import RiverChartController from "./controllers/river_chart_controller.js"
import ModalTriggerController from "./controllers/modal_trigger_controller.js"

window.Stimulus = Application.start()
Stimulus.register("withdrawal-form", WithdrawalFormController)
Stimulus.register("river-chart", RiverChartController)
Stimulus.register("modal-trigger", ModalTriggerController)
