# frozen_string_literal: true

require_relative "../component"

module SlimPickins
  module Components
    # A data table from headers and rows. Cells are escaped like any other
    # value; pass sp_safe for a cell that really is markup.
    #
    #   = ui_table ["Name", "Type"], [["text", "String"]]
    class Table < Component
      def initialize(headers, rows, options = {})
        @headers = headers
        @rows = rows
        @options = options
      end

      def render
        tag(:table, safe(head + body),
            @options.merge(class: base_class + Array(@options[:class])))
      end

      private

      def head
        return "" if @headers.nil? || @headers.empty?

        tag(:thead, tag(:tr, safe(@headers.map { |h| tag(:th, h) }.join)))
      end

      def body
        tag(:tbody, safe(@rows.map { |row|
          tag(:tr, safe(row.map { |cell| tag(:td, cell) }.join))
        }.join))
      end
    end
  end
end
