# frozen_string_literal: true

require "slim_pickins"

# The site's own navigation bar.
#
#   navigation Abide
#       Dashboard
#       Accounts
#       Portfolios
#
# The subject is the brand, which always links home. The items are
# destinations: each one is at once the caption a reader sees and the identity
# of the page it leads to, so a view names a page without spelling its URL and
# without asking which page it is already on.
class Navigation < SlimPickins::Word
  HOME = "/"

  # A destination's path is its own name, lowercased. These are the two that
  # are not, declared once here rather than three times in the layout.
  #
  # With three destinations the convention is barely carrying its weight; if
  # the exceptions keep outnumbering it, the rule to keep is the table.
  PATHS = {
    "Dashboard"  => HOME,
    "Portfolios" => "/portfolios/manage"
  }.freeze

  def render
    tag(:nav, class: "sp-navigation") do
      tag(:div, class: "sp-page sp-page--wide") do
        tag(:div, class: "sp-cluster sp-cluster--between sp-navigation__bar") do
          safe(brand + destinations)
        end
      end
    end
  end

  private

  def brand = tag(:a, subject, class: "sp-navigation__brand", href: HOME)

  def destinations
    tag(:div, class: "sp-navigation__links") do
      safe(items.map { |label| destination(label) }.join)
    end
  end

  def destination(label)
    path = path_for(label)
    here = "sp-navigation__link--here" if here?(path)

    tag(:a, label, class: ["sp-navigation__link", here].compact, href: path)
  end

  def path_for(label) = PATHS.fetch(label) { "/#{label.downcase}" }

  def here?(path) = view.request.path == path
end
