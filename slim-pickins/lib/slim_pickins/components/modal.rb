# frozen_string_literal: true

require_relative "../component"

module SlimPickins
  module Components
    # A dialog, hidden until its controller opens it.
    #
    #   = ui_modal id: "add-event", title: "Add Portfolio Event" do
    #     form ...
    class Modal < Component
      needs_controller

      def initialize(title:, id: nil, **options, &body)
        @title = title
        @id = id
        @options = options
        @body = body
      end

      def render
        attrs = @options.merge(
          class: base_class + Array(@options[:class]),
          role: "dialog",
          "aria-modal": "true",
          "aria-hidden": "true",
          data: with_controller(@options[:data] || {})
                  .merge(action: "click->#{self.class.controller}#dismiss")
        )
        attrs[:id] = @id if @id

        tag(:div, attrs) { tag(:div, safe(header + body), class: element_class("content")) }
      end

      private

      def header
        tag(:header, safe(tag(:h3, @title, class: element_class("title")) + close),
            class: element_class("header"))
      end

      def close
        tag(:button, safe("&times;"),
            type: "button",
            class: element_class("close"),
            "aria-label": "Close",
            "data-action": "click->#{self.class.controller}#close")
      end

      def body
        tag(:div, class: element_class("body")) { @body.call }
      end
    end
  end
end
