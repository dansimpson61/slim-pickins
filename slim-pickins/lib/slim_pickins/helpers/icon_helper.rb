# frozen_string_literal: true

module SlimPickins
  module Helpers
    module IconHelper
      # Heroicons (outline). Kept as bare path data so icons need no sprite
      # sheet, no build step, and no network.
      ICON_PATHS = {
        pencil: "M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L10.582 16.07a4.5 4.5 0 01-1.897 1.13l-2.685.8.8-2.685a4.5 4.5 0 011.13-1.897L16.863 4.487zm0 0L19.5 7.125",
        trash: "M14.74 9l-.346 9m-4.788 0L9.26 9m9.968-3.21c.342.052.682.107 1.022.166m-1.022-.165L18.16 19.673a2.25 2.25 0 01-2.244 2.077H8.084a2.25 2.25 0 01-2.244-2.077L4.772 5.79m14.456 0a48.108 48.108 0 00-3.478-.397m-12 .562c.34-.059.68-.114 1.022-.165m0 0a48.11 48.11 0 013.478-.397m7.5 0v-.916c0-1.18-.91-2.164-2.09-2.201a51.964 51.964 0 00-3.32 0c-1.18.037-2.09 1.022-2.09 2.201v.916m7.5 0a48.667 48.667 0 00-7.5 0",
        archive: "M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5m8.25 3v6.75m0 0l-3-3m3 3l3-3M3.375 7.5h17.25c.621 0 1.125-.504 1.125-1.125v-1.5c0-.621-.504-1.125-1.125-1.125H3.375c-.621 0-1.125.504-1.125 1.125v1.5c0 .621.504 1.125 1.125 1.125z",
        plus: "M12 4.5v15m7.5-7.5h-15",
        close: "M6 18L18 6M6 6l12 12",
        check: "M4.5 12.75l6 6 9-13.5",
        restore: "M9 15L3 9m0 0l6-6M3 9h12a6 6 0 010 12h-3"
      }.freeze

      # Renders an inline SVG icon.
      #
      #   == ui_icon :trash
      #   == ui_button ui_icon(:pencil), :neutral, title: "Edit"
      #
      # @param name [Symbol] one of ICON_PATHS
      def ui_icon(name, **options)
        path = ICON_PATHS.fetch(name.to_sym) do
          raise ArgumentError, "unknown icon #{name.inspect}; have #{ICON_PATHS.keys.join(', ')}"
        end

        options[:class] = ["sp-icon", options[:class]].compact
        attrs = build_attributes(options.merge(
          xmlns: "http://www.w3.org/2000/svg",
          fill: "none",
          viewBox: "0 0 24 24",
          "stroke-width": "1.5",
          stroke: "currentColor",
          "aria-hidden": "true"
        ))

        sp_safe(%(<svg#{attrs}><path stroke-linecap="round" stroke-linejoin="round" d="#{path}"></path></svg>))
      end
    end
  end
end
