# frozen_string_literal: true

require_relative "../component"

module SlimPickins
  module Components
    # A list whose order the reader can change. POSTs the new order.
    #
    #   = ui_sortable_list url: "/todos/sort"
    #     = ui_sortable_item todo.id do
    #       span = todo.title
    class SortableList < Component
      needs_controller

      def initialize(url:, **options, &body)
        @url = url
        @options = options
        @body = body
      end

      def render
        data = with_controller(@options[:data] || {}).merge(
          "#{self.class.controller}-url-value": @url,
          "#{self.class.controller}-animation-value": 150
        )

        tag(:ul, @options.merge(class: base_class + Array(@options[:class]), data: data), &@body)
      end
    end
  end
end
