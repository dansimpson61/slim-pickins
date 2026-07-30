# frozen_string_literal: true

module SlimPickins
  module Helpers
    module IconHelper
      def ui_icon(name, **options)
        Components::Icon.new(name, options).render_in(self)
      end
    end
  end
end
