# frozen_string_literal: true

module SlimPickins
  module Helpers
    module ListHelper
      # Renders a sortable list container.
      # items should be rendered inside with `ui_sortable_item`.
      #
      # @param url [String] The URL to post order updates to
      def ui_sortable_list(url:, **options, &block)
        options[:class] = ["sp-sortable-list", options[:class]].compact
        
        data = {
          controller: "sp-sortable",
          "sp-sortable-url-value": url,
          "sp-sortable-animation-value": 150
        }
        
        options[:data] = (options[:data] || {}).merge(data)
        
        sp_tag(:ul, options, &block)
      end

      # Renders an item within a sortable list.
      #
      # @param id [String/Integer] Unique ID for the item (sent to server)
      def ui_sortable_item(id, **options, &block)
        options[:class] = ["sp-sortable-item", options[:class]].compact
        options[:"data-id"] = id
        
        # Handle handle option if present, otherwise whole item is draggable
        handle_html = options.delete(:handle) ? sp_tag(:span, "☰", class: "sp-sortable-handle") : ""
        
        sp_tag(:li, options) do
          content = capture(&block)
          handle_html + content
        end
      end
    end
  end
end
