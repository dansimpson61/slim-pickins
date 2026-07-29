// Slim-Pickins behaviour, shipped alongside the helpers that emit it.
//
// Every controller here backs a `ui_*` helper in lib/. Anything a helper does
// not emit belongs in the consuming application, not in this file.
//
// Consumers supply Stimulus and SortableJS themselves, via an import map:
//
//   "@hotwired/stimulus": "/your/path/stimulus.js"
//   "sortablejs":         "/your/path/sortable.esm.js"
//
// Then, in your application.js:
//
//   import { Application } from "@hotwired/stimulus"
//   import { registerSlimPickins } from "/assets/js/slim_pickins.js"
//
//   const application = Application.start()
//   registerSlimPickins(application)

import SpFlashController from "./controllers/sp_flash_controller.js"
import SpInlineEditController from "./controllers/sp_inline_edit_controller.js"
import SpSortableController from "./controllers/sp_sortable_controller.js"
import SpModalController from "./controllers/sp_modal_controller.js"

export { SpFlashController, SpInlineEditController, SpSortableController, SpModalController }

// Maps each controller to the identifier its helper emits.
export const controllers = {
    "sp-flash": SpFlashController,
    "sp-inline-edit": SpInlineEditController,
    "sp-sortable": SpSortableController,
    "sp-modal": SpModalController
}

// Registers every Slim-Pickins controller on a Stimulus application.
export function registerSlimPickins(application) {
    for (const [identifier, controller] of Object.entries(controllers)) {
        application.register(identifier, controller)
    }
    return application
}
