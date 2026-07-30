# frozen_string_literal: true

require_relative "../component"

module SlimPickins
  module Components
    # Source shown literally. Escapes unconditionally: code must read as code
    # even when it is markup a helper produced.
    #
    #   = ui_code '= ui_button "Save", :primary'
    class Code < Component
      def initialize(source, options = {})
        @source = source
        @options = options
      end

      def render
        tag(:pre, tag(:code, safe(view.escape_html(@source))),
            @options.merge(class: base_class + Array(@options[:class])))
      end
    end
  end
end
