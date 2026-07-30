# frozen_string_literal: true

require_relative "../component"

module SlimPickins
  module Components
    # An action. Renders an <a> when given href:, so a link that looks like a
    # button is still a link.
    #
    #   = ui_button "Save", :primary
    class Button < Component
      slug "btn"

      VARIANCES = %i[primary neutral danger].freeze

      def initialize(text, variance = :neutral, options = {})
        @text = text
        @variance = variance
        @options = options
      end

      def render
        element = @options[:href] ? :a : :button
        tag(element, @text, @options.merge(class: base_class(@variance) + Array(@options[:class])))
      end
    end
  end
end
