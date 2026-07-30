# frozen_string_literal: true

require_relative "../component"

module SlimPickins
  module Components
    # A contained surface. The fundamental grouping element.
    #
    #   = ui_card "Project Alpha" do
    #     p Status: Active
    class Card < Component
      def initialize(title = nil, options = {}, &body)
        @title = title
        @options = options
        @body = body
      end

      def render
        tag(:article, @options.merge(class: base_class + Array(@options[:class]))) do
          safe(header + body)
        end
      end

      private

      def header
        return "" unless @title

        tag(:header, tag(:h3, @title, class: element_class("title")),
            class: element_class("header"))
      end

      def body
        tag(:div, class: element_class("body")) { @body.call }
      end
    end
  end
end
