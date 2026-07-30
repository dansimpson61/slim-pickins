# frozen_string_literal: true

module SlimPickins
  module Helpers
    module InteractionHelper
      def ui_button(text, variance = :neutral, options = {})
        Components::Button.new(text, variance, options).render_in(self)
      end
    end
  end
end
