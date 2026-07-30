# frozen_string_literal: true

require_relative "../component"

module SlimPickins
  module Components
    # An ephemeral message that dismisses itself.
    #
    #   = ui_flash :notice, "Changes saved."
    class Flash < Component
      needs_controller

      VARIANTS = %i[notice alert info].freeze

      def initialize(variant, message)
        @variant = variant
        @message = message
      end

      def render
        return nil unless @message

        tag(:div, @message,
            class: base_class(@variant),
            role: "alert",
            data: with_controller)
      end
    end
  end
end
