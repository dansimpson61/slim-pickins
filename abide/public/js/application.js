import { Application } from "@hotwired/stimulus"
import { registerSlimPickins } from "/assets/js/slim_pickins.js"

// abide's own behaviour. Anything a slim-pickins helper emits is registered
// by registerSlimPickins instead of being duplicated here.
import WithdrawalFormController from "./controllers/withdrawal_form_controller.js"
import RiverChartController from "./controllers/river_chart_controller.js"
import AutoSubmitController from "./controllers/auto_submit_controller.js"
import ValuationController from "./controllers/valuation_controller.js"
import PortfolioManagerController from "./controllers/portfolio_manager_controller.js"
import CrudActionsController from "./controllers/crud_actions_controller.js"
import AccountCreateController from "./controllers/account_create_controller.js"

window.Stimulus = Application.start()

// sp-flash, sp-inline-edit, sp-sortable, sp-modal
registerSlimPickins(Stimulus)

Stimulus.register("withdrawal-form", WithdrawalFormController)
Stimulus.register("river-chart", RiverChartController)
Stimulus.register("auto-submit", AutoSubmitController)
Stimulus.register("valuation", ValuationController)
Stimulus.register("portfolio-manager", PortfolioManagerController)
Stimulus.register("crud-actions", CrudActionsController)
Stimulus.register("account-create", AccountCreateController)
