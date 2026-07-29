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
      
      # Renders a block of source code. Content is escaped, so it shows
      # literally rather than rendering.
      #
      #   == ui_code '== ui_button "Save", :primary'
      #
      # Pass a block for multi-line samples:
      #
      #   == ui_code do
      #     | == ui_card "Project" do
      #         p Status: Active
      def ui_code(source = nil, **options, &block)
        options[:class] = ["sp-code", options[:class]].compact
        content = block ? capture(&block) : source
        sp_tag(:pre, sp_tag(:code, escape_html(content)), options)
      end

      # Renders a small round status indicator.
      # Variants: :ok, :danger, :pending, :neutral.
      def ui_badge(text, variant = :neutral, **options)
        options[:class] = ["sp-badge", "sp-badge--#{variant}", options[:class]].compact
        sp_tag(:span, text.to_s, options)
      end

      # Renders an inset region, for previews and sample output.
      def ui_well(options = {}, &block)
        options[:class] = ["sp-well", options[:class]].compact
        sp_tag(:div, options) { block.call }
      end

      # Renders a toggleable panel (native <details>)
      def ui_toggle_panel(title, position: :left, &block)
        css_class = ["sp-toggle-panel", "sp-toggle-panel--#{position}"].compact.join(" ")
        
        sp_tag(:details, class: css_class) do
          summary = sp_tag(:summary, title, class: "sp-toggle-panel__summary")
          content = sp_tag(:div, class: "sp-toggle-panel__content") { block.call }
          summary + content
        end
      end
    end
  end
end
