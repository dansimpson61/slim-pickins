# frozen_string_literal: true

require "slim_pickins"

# What the chosen portfolio is worth today, and the means of choosing it.
#
#   portfolio-value Today's Portfolio Value
#
# The subject is what to call the figure. Which portfolios there are, which
# one is chosen, and what it comes to are all things the word can find out --
# so the view says none of them, and the last `selected=(...)` ternary in
# abide goes with them.
class PortfolioValue < SlimPickins::Word
  def render
    safe(chooser + figure)
  end

  private

  def chooser
    tag(:div, class: "sp-cluster") do
      safe(tag(:span, subject, class: "sp-overline") + form)
    end
  end

  # Choosing reloads the page, so this is a GET form that submits itself
  # rather than a controller that fetches.
  def form
    tag(:form, action: "/", data: { controller: "auto-submit" }, method: "get") do
      tag(:select, class: "sp-input sp-input--auto",
                   data: { action: "change->auto-submit#submit" },
                   name: "portfolio_id") { safe(choices) }
    end
  end

  def choices
    portfolios.map { |portfolio| choice(portfolio) }.join
  end

  def choice(portfolio)
    attributes = {}
    attributes[:selected] = "" if portfolio["id"] == chosen["id"]
    attributes[:value] = portfolio["id"]

    tag(:option, portfolio["name"], attributes)
  end

  def figure
    tag(:div, view.ui_money(chosen["balance"]), class: "sp-figure sp-figure--lg")
  end

  def portfolios = view.instance_variable_get("@portfolios") || []
  def chosen = view.instance_variable_get("@portfolio")
end
