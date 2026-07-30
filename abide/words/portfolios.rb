# frozen_string_literal: true

require "slim_pickins"

# The portfolios list, as a grid of cards.
#
#   portfolios
#       Name
#       Id
#       Actions
#       Accounts
#
# The same four lines an `accounts` list would be written in, for something
# that is not a table at all. That is the point of naming aspects rather than
# columns: the view says what each card shows, and this decides that a card is
# the shape and where on it each aspect sits.
class Portfolios < SlimPickins::Collection
  # Aspect => what renders it for one portfolio.
  PARTS = {
    "Name"     => :editable_name,
    "Id"       => :identifier,
    "Actions"  => :actions,
    "Accounts" => :membership
  }.freeze

  # Aspects belonging on the card's top line. The first is the card's title
  # and the rest gather to its right; every other aspect is body.
  HEADING = %w[Name Id Actions].freeze

  # The default portfolio is structural, so it is not ours to delete.
  PERMANENT = 1

  def render
    tag(:div, class: "sp-grid sp-grid--auto sp-grid--loose") do
      safe(members.map { |portfolio| card(portfolio) }.join)
    end
  end

  private

  def card(portfolio)
    wiring = { controller: "crud-actions", "crud-actions-url-value": path_for(portfolio) }

    view.ui_card(class: "sp-row", data: wiring) { safe(heading(portfolio) + body(portfolio)) }
  end

  def heading(portfolio)
    title, *rest = aspects.select { |aspect| HEADING.include?(aspect) }
    return safe("") unless title

    tag(:div, class: "sp-cluster sp-cluster--between") do
      safe(part(title, portfolio) + gathered(rest, portfolio))
    end
  end

  def gathered(rest, portfolio)
    tag(:div, class: "sp-cluster") { safe(rest.map { |aspect| part(aspect, portfolio) }.join) }
  end

  def body(portfolio)
    safe(aspects.reject { |aspect| HEADING.include?(aspect) }
                .map { |aspect| part(aspect, portfolio) }.join)
  end

  def part(aspect, portfolio)
    renderer = PARTS.fetch(aspect) do
      raise ArgumentError, "a portfolio has no #{aspect.inspect}; try #{PARTS.keys.join(', ')}"
    end

    send(renderer, portfolio)
  end

  # --- the aspects -------------------------------------------------------

  def editable_name(portfolio)
    view.ui_text_field("name", portfolio["name"], url: path_for(portfolio), method: "PUT")
  end

  def identifier(portfolio) = view.ui_pill("ID: #{portfolio['id']}")

  def actions(portfolio)
    return safe("") if portfolio["id"] == PERMANENT

    tag(:div, class: "sp-actions") do
      view.ui_button(view.ui_icon(:trash), :danger,
                     class: "sp-btn--sm sp-btn--icon sp-btn--ghost",
                     title: "Delete", data: { action: "click->crud-actions#delete" })
    end
  end

  def membership(portfolio)
    view.ui_well do
      safe(tag(:strong, "Associated Accounts:") + choices(portfolio))
    end
  end

  def choices(portfolio)
    tag(:div, class: "sp-stack sp-stack--tight") do
      safe(accounts.map { |account| choice(account, portfolio) }.join)
    end
  end

  def choice(account, portfolio)
    tag(:label, class: "sp-cluster sp-text-sm") do
      safe(checkbox(account, portfolio) +
           view.sp_escape(account["name"]) +
           tag(:span, "(#{account['type']})", class: "sp-text-sm sp-text-muted"))
    end
  end

  def checkbox(account, portfolio)
    attributes = {}
    attributes[:checked] = "" if held_by(portfolio).include?(account["id"])
    attributes[:data] = { action: "change->portfolio-manager#addAccount",
                          portfolio_id: portfolio["id"] }
    attributes[:type] = "checkbox"
    attributes[:value] = account["id"]

    tag(:input, nil, attributes)
  end

  # --- values ------------------------------------------------------------

  # Asked once per portfolio, not once per checkbox.
  def held_by(portfolio)
    @held_by ||= {}
    @held_by[portfolio["id"]] ||=
      ledger.get_portfolio_accounts(portfolio["id"]).map { |account| account["id"] }
  end

  def accounts = view.instance_variable_get("@accounts") || []
  def ledger = view.instance_variable_get("@ledger")
end
