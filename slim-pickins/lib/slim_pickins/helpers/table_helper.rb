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

        # join and + drop the safe marking, so each composition is re-marked.
        head = if headers.nil? || headers.empty?
                 ""
               else
                 sp_tag(:thead, sp_tag(:tr, sp_safe(headers.map { |h| sp_tag(:th, h) }.join)))
               end

        body = sp_safe(rows.map { |row|
          sp_tag(:tr, sp_safe(row.map { |cell| sp_tag(:td, cell) }.join))
        }.join)

        sp_tag(:table, sp_safe(head + sp_tag(:tbody, body)), options)
      end
    end
  end
end
