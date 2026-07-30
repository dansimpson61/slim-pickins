# frozen_string_literal: true

module SlimPickins
  module Helpers
    module TableHelper
      def ui_table(headers, rows, **options)
        Components::Table.new(headers, rows, options).render_in(self)
      end
    end
  end
end
