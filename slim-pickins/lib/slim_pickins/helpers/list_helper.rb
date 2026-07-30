# frozen_string_literal: true

module SlimPickins
  module Helpers
    module ListHelper
      def ui_sortable_list(url:, **options, &block)
        Components::SortableList.new(url: url, **options, &block).render_in(self)
      end

      def ui_sortable_item(id, **options, &block)
        Components::SortableItem.new(id, **options, &block).render_in(self)
      end
    end
  end
end
