# frozen_string_literal: true

require_relative "../component"

module SlimPickins
  module Components
    # One row of a SortableList. Its drag affordance is scoped in CSS to the
    # list's controller, so an item outside a sortable list looks inert --
    # because it is.
    class SortableItem < Component
      def initialize(id, **options, &body)
        @id = id
        @options = options
        @body = body
      end

      def render
        handle = @options.delete(:handle) ? tag(:span, "☰", class: "sp-sortable-handle") : ""

        tag(:li, @options.merge(class: base_class + Array(@options[:class]), "data-id": @id)) do
          safe(handle + view.capture(&@body))
        end
      end
    end
  end
end
