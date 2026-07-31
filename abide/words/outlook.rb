# frozen_string_literal: true

require "slim_pickins"

# A gauge with a word for how things are going.
#
#   outlook Sustainability Outlook
#       On Track
#
# The subject names the gauge and the item is its reading.
#
# The bar is a placeholder: its fill is fixed in CSS, because abide cannot yet
# say how sustainable a portfolio is. The reading is written in the view so
# that the day it becomes real, only this word changes.
class Outlook < SlimPickins::Word
  def render
    tag(:div, class: "sp-stack sp-stack--tight") do
      safe(tag(:span, subject, class: "sp-overline") + gauge)
    end
  end

  private

  def gauge
    tag(:div, class: "sp-cluster") { safe(meter + reading) }
  end

  # The fill is a fixed width in CSS; there is nothing yet to measure.
  def meter
    tag(:div, class: "sp-meter") { tag(:div, class: "sp-meter__fill") }
  end

  def reading = tag(:span, items.first, class: "sp-text-sm sp-text-muted")
end
