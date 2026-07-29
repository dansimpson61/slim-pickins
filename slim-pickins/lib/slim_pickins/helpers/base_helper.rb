# frozen_string_literal: true

module SlimPickins
  module Helpers
    # A String already known to be markup. Helpers return these, so nesting a
    # helper inside another passes through untouched, while a plain String --
    # anything that came from a user, a database, or a template author writing
    # text -- is escaped on the way in.
    #
    # Ruby drops the subclass across +, join, and interpolation, so safety is
    # never inferred. Helpers mark their own output with `sp_safe`.
    class SafeString < String
      def html_safe?
        true
      end
    end

    module BaseHelper
      # Elements that may close themselves. Everything else needs a closing
      # tag even when empty: browsers parse <div /> as an unclosed <div> and
      # nest the rest of the page inside it.
      VOID_ELEMENTS = %i[
        area base br col embed hr img input link meta param source track wbr
      ].freeze

      # Renders a tag with the given name, content, and options.
      # If a block is given, the content of the block is captured and rendered inside the tag.
      #
      # Scalar content is escaped unless already marked safe. Block content is
      # rendered markup by construction, so it is trusted.
      def sp_tag(name, content_or_options = nil, options = {}, &block)
        if block_given?
          options = content_or_options || {}
          content = sp_safe(block.call)
        else
          content = content_or_options
        end

        attrs = build_attributes(options)

        if content
          sp_safe("<#{name}#{attrs}>#{sp_escape(content)}</#{name}>")
        elsif VOID_ELEMENTS.include?(name.to_sym)
          sp_safe("<#{name}#{attrs} />")
        else
          sp_safe("<#{name}#{attrs}></#{name}>")
        end
      end

      # Marks a String as markup, exempting it from escaping.
      # Use in a template when a value really is HTML:
      #
      #   == ui_table ["Name"], [[sp_safe("<code>:primary</code>")]]
      def sp_safe(value)
        value.is_a?(SafeString) ? value : SafeString.new(value.to_s)
      end

      # Escapes unless the value has already been vouched for.
      def sp_escape(value)
        return sp_safe("") if value.nil?
        return value if value.respond_to?(:html_safe?) && value.html_safe?

        sp_safe(escape_html(value))
      end

      # Escapes regardless of any safety marking, for content that must render
      # literally no matter where it came from.
      def escape_html(value)
        value.to_s
             .gsub("&", "&amp;")
             .gsub("<", "&lt;")
             .gsub(">", "&gt;")
             .gsub('"', "&quot;")
             .gsub("'", "&#39;")
      end

      private

      def build_attributes(options)
        return "" if options.nil? || options.empty?

        attrs = []
        options.each do |key, value|
          if key == :data && value.is_a?(Hash)
            # Flatten data hash: data: { controller: "foo" } -> data-controller="foo"
            value.each do |k, v|
              dashed_key = k.to_s.gsub('_', '-')
              attrs << "data-#{dashed_key}=\"#{escape_attr(v)}\""
            end
          elsif key == :class
            # Handle class arrays
            val = Array(value).compact.join(" ")
            attrs << "class=\"#{escape_attr(val)}\"" unless val.empty?
          else
            attrs << "#{key}=\"#{escape_attr(value)}\""
          end
        end

        attrs.empty? ? "" : " " + attrs.join(" ")
      end

      # Attribute values are always escaped; there is no safe-HTML concept
      # inside a quoted attribute.
      def escape_attr(value)
        escape_html(value)
      end
    end
  end
end
