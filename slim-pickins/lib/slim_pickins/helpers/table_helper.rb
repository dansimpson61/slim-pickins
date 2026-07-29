# frozen_string_literal: true

module SlimPickins
  module Helpers
    module TableHelper
      # Renders a data table.
      #
      # Cell content is inserted as-is, so callers may pass markup:
      #
      #   ui_table(
      #     ["Name", "Type", "Description"],
      #     [["text", "String", "The label of the button."]]
      #   )
      #
      # @param headers [Array<String>, nil] header cells; omit for a headless table
      # @param rows [Array<Array>] one array of cells per row
      def ui_table(headers, rows, **options)
        options[:class] = ["sp-table", options[:class]].compact

        head = if headers.nil? || headers.empty?
                 ""
               else
                 sp_tag(:thead, sp_tag(:tr, headers.map { |h| sp_tag(:th, h.to_s) }.join))
               end

        body = rows.map { |row|
          sp_tag(:tr, row.map { |cell| sp_tag(:td, cell.to_s) }.join)
        }.join

        sp_tag(:table, head + sp_tag(:tbody, body), options)
      end
    end
  end
end
