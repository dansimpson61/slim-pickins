# frozen_string_literal: true

module SlimPickins
  module Helpers
    module ModalHelper
      def ui_modal(title:, id: nil, **options, &block)
        Components::Modal.new(title: title, id: id, **options, &block).render_in(self)
      end

      # A button that opens the modal with the given id. Carries its own
      # sp-modal scope so Stimulus can route the action.
      def ui_modal_trigger(text, dialog:, variance: :primary, **options)
        controller = Components::Modal.controller
        options[:data] = (options[:data] || {}).merge(
          controller: controller,
          action: "click->#{controller}#open",
          "#{controller}-dialog-param": dialog
        )
        ui_button(text, variance, options)
      end
    end
  end
end
