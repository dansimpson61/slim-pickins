# frozen_string_literal: true

module SlimPickins
  module Helpers
    module LayoutHelper
      # Renders a card component.
      # @param title [String] Optional title for the card header
      def ui_card(title = nil, options = {}, &block)
        options[:class] = ["sp-card", options[:class]].compact
        
        sp_tag(:article, options) do
          header = title ? sp_tag(:header, sp_tag(:h3, title, class: "sp-card__title"), class: "sp-card__header") : ""
          body = sp_tag(:div, class: "sp-card__body") { block.call }
          header + body
        end
      end

      # Renders a flash message.
      def ui_flash(type, message)
        return unless message
        css_class = "sp-flash sp-flash--#{type}"
        sp_tag(:div, message, class: css_class, role: "alert", "data-controller": "sp-flash")
      end
      
      # Renders a toggleable panel (native <details> enhanced with Stimulus)
      def ui_toggle_panel(title, position: :left, &block)
        css_class = ["sp-toggle-panel", "sp-toggle-panel--#{position}"].compact.join(" ")
        
        sp_tag(:details, class: css_class, "data-controller": "sp-details") do
          summary = sp_tag(:summary, title, class: "sp-toggle-panel__summary", "data-action": "click->sp-details#toggle")
          content = sp_tag(:div, class: "sp-toggle-panel__content") { block.call }
          summary + content
        end
      end
    end
  end
end
