# frozen_string_literal: true

module SlimPickins
  module Helpers
    module InteractionHelper
      # Renders a button.
      def ui_button(text, variance = :neutral, options = {})
        tag_name = options[:href] ? :a : :button
        
        css_class = ["sp-btn", "sp-btn--#{variance}", options[:class]].compact
        options = options.merge(class: css_class)
        
        sp_tag(tag_name, text, options)
      end
    end
  end
end
