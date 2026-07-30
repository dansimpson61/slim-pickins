# frozen_string_literal: true

module SlimPickins
  module Helpers
    # Façades. Each one names a component and gets out of the way; the DSL a
    # template writes has not changed.
    module LayoutHelper
      # Options are keywords, as the docs have always said. Taking them
      # positionally meant `ui_card class: "sp-row"` bound the whole hash to
      # the title, printing it as a heading and dropping the attributes.
      def ui_card(title = nil, **options, &block)
        Components::Card.new(title, options, &block).render_in(self)
      end

      def ui_flash(variant, message)
        Components::Flash.new(variant, message).render_in(self)
      end

      def ui_code(source = nil, **options, &block)
        Components::Code.new(block ? capture(&block) : source, options).render_in(self)
      end

      def ui_badge(text, variant = :neutral, **options)
        Components::Badge.new(text, variant, options).render_in(self)
      end

      def ui_well(options = {}, &block)
        Components::Well.new(options, &block).render_in(self)
      end

      def ui_toggle_panel(title = nil, position: :left, &block)
        enclosing = @sp_pending_summary
        @sp_pending_summary = nil
        Components::TogglePanel.new(title, position: position, &block).render_in(self)
      ensure
        @sp_pending_summary = enclosing
      end

      # <summary> must be a direct child of <details>, so this stashes its
      # markup rather than emitting it where it is written.
      def ui_summary(options = {}, &block)
        options[:class] = ["sp-toggle-panel__summary", options[:class]].compact
        @sp_pending_summary = sp_tag(:summary, options) { block.call }
        sp_safe("")
      end

      # Handed to TogglePanel once its body has run, since `ui_summary` can
      # only have stashed by then.
      def sp_take_summary
        summary = @sp_pending_summary
        @sp_pending_summary = nil
        summary
      end
    end
  end
end
