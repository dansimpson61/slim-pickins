# frozen_string_literal: true

require_relative "../component"

module SlimPickins
  module Components
    # A small text pill, for types and short states.
    #
    #   = ui_pill account["type"]
    class Pill < Component
      def initialize(text, options = {})
        @text = text
        @options = options
      end

      def render
        tag(:span, @text.to_s,
            @options.merge(class: base_class + Array(@options[:class])))
      end
    end
  end
end
