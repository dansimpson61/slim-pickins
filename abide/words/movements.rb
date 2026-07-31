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
class Movements < SlimPickins::Tabular
  renders "Description" => :occasion,
          "Amount"      => :amount,
          "Actions"     => :actions

  private

  # A feed, not a data table: the cells need no columns named above them.
  def headings? = false

  def numeric = %w[Amount]

  # Having nothing to show is a thing to say, not an empty card.
  def when_empty = tag(:p, "No movements recorded yet.", class: "sp-text-muted")

  # --- the aspects -------------------------------------------------------

  # One aspect, two values: what happened, and when. A column could not have
  # said this, which is the whole reason an aspect is not one.
  def occasion(movement)
    safe(tag(:div, movement["description"], class: "sp-text-strong") +
         tag(:div, movement["date"], class: "sp-text-sm sp-text-muted"))
  end

  def amount(movement)
    value = movement["amount"].to_f

    tag(:div, view.ui_money(value, sign: true),
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
end
