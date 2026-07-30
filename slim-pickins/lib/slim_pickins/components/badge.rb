# frozen_string_literal: true

require_relative "../component"

module SlimPickins
  module Components
    # A small round status indicator.
    #
    #   = ui_badge "OK", :ok
    class Badge < Component
      VARIANTS = %i[ok danger pending neutral].freeze

      def initialize(text, variant = :neutral, options = {})
        @text = text
        @variant = variant
        @options = options
      end

      def render
        tag(:span, @text.to_s,
            @options.merge(class: base_class(@variant) + Array(@options[:class])))
      end
    end
  end
end
