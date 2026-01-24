import { Application } from "https://unpkg.com/@hotwired/stimulus/dist/stimulus.js"
import WithdrawalFormController from "./controllers/withdrawal_form_controller.js"
import RiverChartController from "./controllers/river_chart_controller.js"
import ModalTriggerController from "./controllers/modal_trigger_controller.js"
import AutoSubmitController from "./controllers/auto_submit_controller.js"
import ValuationController from "./controllers/valuation_controller.js"
import PortfolioManagerController from "./controllers/portfolio_manager_controller.js"
import InlineEditController from "./controllers/inline_edit_controller.js"
import CrudActionsController from "./controllers/crud_actions_controller.js"
import AccountCreateController from "./controllers/account_create_controller.js"

window.Stimulus = Application.start()
Stimulus.register("withdrawal-form", WithdrawalFormController)
Stimulus.register("river-chart", RiverChartController)
Stimulus.register("modal-trigger", ModalTriggerController)
Stimulus.register("auto-submit", AutoSubmitController)
Stimulus.register("valuation", ValuationController)
Stimulus.register("portfolio-manager", PortfolioManagerController)
Stimulus.register("inline-edit", InlineEditController)
Stimulus.register("crud-actions", CrudActionsController)
Stimulus.register("account-create", AccountCreateController)
