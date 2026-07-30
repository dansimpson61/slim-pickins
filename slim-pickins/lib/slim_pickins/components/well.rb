# frozen_string_literal: true

require_relative "../component"

module SlimPickins
  module Components
    # An inset region, for previews and sample output.
    #
    #   = ui_well do
    #     = rendered
    class Well < Component
      def initialize(options = {}, &body)
        @options = options
        @body = body
      end

      def render
        tag(:div, @options.merge(class: base_class + Array(@options[:class]))) { @body.call }
      end
    end
  end
end
