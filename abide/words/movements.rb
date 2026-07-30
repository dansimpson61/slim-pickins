# frozen_string_literal: true

require "slim_pickins"

# What has happened lately, and what is about to.
#
#   movements
#       Description
#       Amount
#       Actions
#
# A feed rather than a data table, so it has no headings -- an aspect here is
# a cell with nothing above it. Naming aspects rather than columns is what
# lets the same three lines mean that.
class Movements < SlimPickins::Collection
  renders "Description" => :occasion,
          "Amount"      => :amount,
          "Actions"     => :actions

  # Having nothing to show is a thing to say, not an empty card.
  NOTHING_YET = "No movements recorded yet."

  def render
    return tag(:p, NOTHING_YET, class: "sp-text-muted") if empty?

    tag(:table, class: "sp-table") { body }
  end

  private

  def body
    tag(:tbody) { safe(members.map { |movement| row(movement) }.join) }
  end

  def row(movement)
    tag(:tr) { safe(aspects.map { |aspect| cell(aspect, movement) }.join) }
  end

  def cell(aspect, movement)
    tag(:td, part(aspect, movement), class: ("sp-numeric" if aspect == "Amount"))
  end

  # --- the aspects -------------------------------------------------------

  # One aspect, two values: what happened, and when. A column could not have
  # said this, which is the whole reason an aspect is not one.
  def occasion(movement)
    safe(tag(:div, movement["description"], class: "sp-text-strong") +
         tag(:div, movement["date"], class: "sp-text-sm sp-text-muted"))
  end

  def amount(movement)
    value = movement["amount"].to_f

    tag(:div, signed(value),
        class: ["sp-text-strong", ("text-accent-dark" unless value.negative?)].compact)
  end

  def actions(movement)
    tag(:div, class: "sp-actions") { safe(edit(movement) + remove(movement)) }
  end

  def edit(movement)
    icon_button(:pencil, :neutral, "Edit",
                action: "click->withdrawal-form#edit",
                id: movement["id"],
                description: movement["description"],
                amount: movement["amount"],
                date: movement["date"],
                taxable: movement["tax_info"]["is_taxable"])
  end

  def remove(movement)
    icon_button(:trash, :danger, "Delete",
                action: "click->withdrawal-form#delete", id: movement["id"])
  end

  def icon_button(icon, variance, title, **data)
    view.ui_button(view.ui_icon(icon), variance,
                   class: "sp-btn--sm sp-btn--icon sp-btn--ghost",
                   title: title, data: data)
  end

  # --- values ------------------------------------------------------------

  # This list spells the sign out and leaves the figure raw, where the
  # accounts table separates thousands and never writes a plus. Two formats
  # for the same idea; both are left exactly as they were.
  def signed(value) = value.negative? ? "- $#{value.abs}" : "+ $#{value}"
end
