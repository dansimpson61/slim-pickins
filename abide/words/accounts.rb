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
class Accounts < SlimPickins::Collection
  # Aspect => what renders that cell of a row.
  CELLS = {
    "Name"    => :editable_name,
    "Type"    => :kind,
    "Balance" => :balance,
    "Actions" => :actions
  }.freeze

  # Aspects whose heading is right-aligned. `Actions` carrying sp-numeric
  # looks like a leftover -- it right-aligns a heading over left-aligned
  # buttons -- but this is the table as it stands.
  RIGHT_ALIGNED = %w[Balance Actions].freeze

  def render
    tag(:table, class: "sp-table") { safe(head + body) }
  end

  private

  def head
    tag(:thead) { tag(:tr) { safe(aspects.map { |aspect| heading(aspect) }.join) } }
  end

  def heading(aspect)
    tag(:th, aspect, class: ("sp-numeric" if RIGHT_ALIGNED.include?(aspect)))
  end

  def body
    tag(:tbody) { safe(members.map { |account| row(account) }.join) }
  end

  def row(account)
    wiring = { controller: "crud-actions", "crud-actions-url-value": path_for(account) }

    tag(:tr, data: wiring) { safe(aspects.map { |aspect| cell(aspect, account) }.join) }
  end

  def cell(aspect, account)
    renderer = CELLS.fetch(aspect) do
      raise ArgumentError, "an account has no #{aspect.inspect}; try #{CELLS.keys.join(', ')}"
    end

    tag(:td, send(renderer, account), class: ("sp-numeric" if aspect == "Balance"))
  end

  # --- the aspects -------------------------------------------------------

  def editable_name(account)
    view.ui_text_field("name", account["name"], url: path_for(account), method: "PUT")
  end

  def kind(account) = view.ui_pill(account["type"])

  def balance(account) = "$#{separated(balance_of(account))}"

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

  # The thousands separator this table has always used. It renders 2000000.0
  # as "2,000,000.0" and -6400.0 as "-6,400.0" -- trailing zero and misplaced
  # sign included, so the page is unchanged by the move. Now that it lives in
  # one place rather than two, correcting it is a single edit.
  def separated(amount) = amount.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\1,').reverse
end
