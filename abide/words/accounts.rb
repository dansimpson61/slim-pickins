# frozen_string_literal: true

require "slim_pickins"

# The accounts table.
#
#   accounts
#       Name
#       Type
#       Balance
#       Actions
#
# Each line names an aspect of one account, and their order is the order of
# the columns. Everything else -- which cell can be edited, which is money,
# what a row's buttons do and when they appear -- is settled here, once,
# instead of across thirty lines of template.
class Accounts < SlimPickins::Tabular
  renders "Name"    => :editable_name,
          "Type"    => :kind,
          "Balance" => :balance,
          "Actions" => :actions

  private

  def numeric = %w[Balance]

  # `Actions` carrying sp-numeric looks like a leftover -- it right-aligns a
  # heading over left-aligned buttons -- but this is the table as it stands.
  def numeric_headings = %w[Balance Actions]

  # Every row can be renamed, archived, and deleted where it sits.
  def row_attributes(account)
    { data: { controller: "crud-actions", "crud-actions-url-value": path_for(account) } }
  end

  # --- the aspects -------------------------------------------------------

  def editable_name(account)
    view.ui_text_field("name", account["name"], url: path_for(account), method: "PUT")
  end

  def kind(account) = view.ui_pill(account["type"])

  def balance(account) = view.ui_money(balance_of(account))

  def actions(account)
    tag(:div, class: "sp-actions") { safe(buttons(account).join) }
  end

  # An archived account offers only its way back. A market account is valued
  # by the market, so it is not ours to update, archive, or delete.
  def buttons(account)
    return [restore] unless account["is_active"] == 1
    return [] if account["type"] == "market"

    [update_value(account), archive, delete]
  end

  def update_value(account)
    view.ui_button("Update Value", :neutral,
                   class: "sp-btn--sm sp-btn--ghost",
                   data: { action: "click->valuation#open", id: account["id"],
                           name: account["name"], balance: balance_of(account) })
  end

  def archive = icon_button(:archive, :neutral, "Archive", "click->crud-actions#archive")
  def delete  = icon_button(:trash, :danger, "Delete", "click->crud-actions#delete")

  def icon_button(icon, variance, title, action)
    view.ui_button(view.ui_icon(icon), variance,
                   class: "sp-btn--sm sp-btn--icon sp-btn--ghost",
                   title: title, data: { action: action })
  end

  def restore
    view.ui_button("Restore", :neutral, class: "sp-btn--sm sp-btn--ghost",
                   data: { action: "click->crud-actions#restore" })
  end

  # --- values ------------------------------------------------------------

  def balance_of(account) = ledger.balance(account["id"])

  def ledger = view.instance_variable_get("@ledger")
end
