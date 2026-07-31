# frozen_string_literal: true

require_relative "collection"

module SlimPickins
  # A collection drawn as a table: one row per member, one cell per aspect.
  #
  #   class Accounts < SlimPickins::Tabular
  #     renders "Name" => :editable_name, "Balance" => :balance
  #   end
  #
  # Named for the shape rather than the tag, since `ui_table` is a different
  # thing -- a helper you hand headers and rows to. This is what a word
  # becomes when its members line up.
  #
  # Everything a word might want to differ about has a hook and a plain
  # default, so a word that wants the ordinary table writes only `renders`.
  class Tabular < Collection
    abstract

    def render = empty? ? when_empty : table

    private

    def table = tag(:table, class: "sp-table") { safe(head + body) }

    # A data table names its columns. A feed of what happened lately does not,
    # and saying so is the only difference between the two.
    def headings? = true

    # Aspects whose cells are right-aligned, and the headings above them,
    # which follow the cells unless a word says otherwise.
    def numeric = []
    def numeric_headings = numeric

    # Attributes for one member's row -- the wiring that makes a row editable,
    # where a word has any.
    def row_attributes(_member) = {}

    # Shown when the collection is empty. An empty table is honest enough by
    # default; a word with something better to say overrides this.
    def when_empty = table

    def head
      return safe("") unless headings?

      tag(:thead) { tag(:tr) { safe(aspects.map { |aspect| heading(aspect) }.join) } }
    end

    def heading(aspect)
      tag(:th, aspect, class: ("sp-numeric" if numeric_headings.include?(aspect)))
    end

    def body
      tag(:tbody) { safe(members.map { |member| row(member) }.join) }
    end

    def row(member)
      tag(:tr, row_attributes(member)) { safe(aspects.map { |a| cell(a, member) }.join) }
    end

    def cell(aspect, member)
      tag(:td, part(aspect, member), class: ("sp-numeric" if numeric.include?(aspect)))
    end
  end
end
