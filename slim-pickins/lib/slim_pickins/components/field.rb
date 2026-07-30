# frozen_string_literal: true

require_relative "../component"

module SlimPickins
  module Components
    # A labelled form control. The block supplies the control itself.
    #
    #   = ui_field "Amount" do
    #     input.sp-input type="number" name="amount"
    class Field < Component
      # Keeps .sp-field-group; .sp-field belongs to TextField.
      slug "field-group"

      def initialize(label, options = {}, &control)
        @label = label
        @options = options
        @control = control
      end

      def render
        tag(:div, @options.merge(class: base_class + Array(@options[:class]))) do
          safe(tag(:label, @label, class: "sp-label") + @control.call)
        end
      end
    end
  end
end
