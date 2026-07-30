# frozen_string_literal: true

require_relative "../component"

module SlimPickins
  module Components
    # Edit in place. Sends the new value as JSON keyed by the field's name,
    # with the verb the consumer asked for.
    #
    #   = ui_text_field "name", account["name"], url: "/accounts/1", method: "PUT"
    class TextField < Component
      # Keeps .sp-field. The controller identifier is now the same name --
      # it used to be a second, unrelated string ("sp-inline-edit").
      slug "field"
      needs_controller

      def initialize(name, value, url:, method: "POST", **options)
        @name = name
        @value = value
        @url = url
        @method = method
        @options = options
      end

      def render
        data = with_controller(@options[:data] || {}).merge(
          "#{self.class.controller}-url-value": @url,
          "#{self.class.controller}-name-value": @name,
          "#{self.class.controller}-method-value": @method,
          action: "click->#{self.class.controller}#edit"
        )

        tag(:div, @options.merge(class: base_class + Array(@options[:class]), data: data)) do
          safe(display + input)
        end
      end

      private

      def display
        tag(:span, @value,
            class: element_class("display"),
            "data-#{self.class.controller}-target": "display")
      end

      def input
        tag(:input, nil,
            type: "text",
            value: @value,
            class: element_class("input"),
            "data-#{self.class.controller}-target": "input",
            "data-action": "blur->#{self.class.controller}#save " \
                           "keydown.enter->#{self.class.controller}#save " \
                           "keydown.esc->#{self.class.controller}#cancel")
      end
    end
  end
end
