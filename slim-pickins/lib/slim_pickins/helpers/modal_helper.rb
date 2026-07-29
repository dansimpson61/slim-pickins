# frozen_string_literal: true

module SlimPickins
  module Helpers
    module ModalHelper
      # Renders a dialog with a titled header and a close control.
      #
      #   == ui_modal id: "add-event", title: "Add Portfolio Event" do
      #     form ...
      #
      # Hidden until the sp-modal controller adds `.sp-modal--open`.
      # Open it with `ui_modal_trigger`, or from your own controller.
      def ui_modal(title:, id: nil, **options, &block)
        options[:class] = ["sp-modal", options[:class]].compact
        options[:id] = id if id
        options[:role] = "dialog"
        options[:"aria-modal"] = "true"
        options[:"aria-hidden"] = "true"
        options[:data] = (options[:data] || {}).merge(
          controller: "sp-modal",
          action: "click->sp-modal#dismiss"
        )

        header = sp_tag(
          :header,
          sp_tag(:h3, title, class: "sp-modal__title") + close_button,
          class: "sp-modal__header"
        )

        sp_tag(:div, options) do
          sp_tag(:div, header + sp_tag(:div, class: "sp-modal__body") { block.call },
                 class: "sp-modal__content")
        end
      end

      # Renders a button that opens the modal with the given id.
      # Carries its own sp-modal scope so Stimulus can route the action.
      def ui_modal_trigger(text, dialog:, variance: :primary, **options)
        options[:data] = (options[:data] || {}).merge(
          controller: "sp-modal",
          action: "click->sp-modal#open",
          "sp-modal-dialog-param": dialog
        )
        ui_button(text, variance, **options)
      end

      private

      def close_button
        sp_tag(:button, "&times;",
               type: "button",
               class: "sp-modal__close",
               "aria-label": "Close",
               "data-action": "click->sp-modal#close")
      end
    end
  end
end
