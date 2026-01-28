# frozen_string_literal: true

module SlimPickins
  module Helpers
    module FormHelper
      # Renders an edit-in-place text field.
      #
      # @param name [String] The form field name
      # @param value [String] The current value
      # @param url [String] The URL to post updates to
      # @param options [Hash] HTML attributes
      def ui_text_field(name, value, url:, **options)
        options[:class] = ["sp-field", options[:class]].compact
        
        # Data attributes for the Stimulus controller
        data = {
          controller: "sp-inline-edit",
          "sp-inline-edit-url-value": url,
          "sp-inline-edit-name-value": name,
          action: "click->sp-inline-edit#edit"
        }
        
        options[:data] = (options[:data] || {}).merge(data)
        
        sp_tag(:div, options) do
          # Display view
          display = sp_tag(:span, value, 
            class: "sp-field__display", 
            "data-sp-inline-edit-target": "display"
          )
          
          # Edit view (hidden by default)
          input = sp_tag(:input, nil, 
            type: "text", 
            value: value, 
            class: "sp-field__input",
            "data-sp-inline-edit-target": "input",
            "data-action": "blur->sp-inline-edit#save keydown.enter->sp-inline-edit#save keydown.esc->sp-inline-edit#cancel"
          )
          
          display + input
        end
      end
    end
  end
end
