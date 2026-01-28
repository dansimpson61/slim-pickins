# frozen_string_literal: true

module SlimPickins
  module Helpers
    module BaseHelper
      # Renders a tag with the given name, content, and options.
      # If a block is given, the content of the block is captured and rendered inside the tag.
      def sp_tag(name, content_or_options = nil, options = {}, &block)
        if block_given?
          options = content_or_options || {}
          content = block.call
        else
          content = content_or_options
        end

        attrs = build_attributes(options)

        if content
          "<#{name}#{attrs}>#{content}</#{name}>"
        else
          "<#{name}#{attrs} />"
        end
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

      def escape_attr(value)
        value.to_s.gsub('"', '&quot;')
      end
    end
  end
end
