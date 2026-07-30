# frozen_string_literal: true

require_relative "../component"

module SlimPickins
  module Components
    # Progressive disclosure on native <details>. No controller: the platform
    # already does the work, and the best javascript is the least javascript.
    #
    #   = ui_toggle_panel "Advanced Settings" do
    #     p Hidden until asked for.
    #
    # Omit the title and open the block with `ui_summary` when the summary
    # line needs markup of its own.
    class TogglePanel < Component
      def initialize(title = nil, position: :left, &body)
        @title = title
        @position = position
        @body = body
      end

      # Body first: a `ui_summary` inside the block has not stashed its markup
      # until the block has run.
      def render
        body = tag(:div, class: element_class("content")) { @body.call }
        tag(:details, safe(summary.to_s + body), class: base_class(@position))
      end

      private

      def summary
        return view.sp_take_summary unless @title

        tag(:summary, @title, class: element_class("summary"))
      end
    end
  end
end
