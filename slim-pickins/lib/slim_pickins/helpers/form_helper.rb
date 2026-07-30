# frozen_string_literal: true

module SlimPickins
  module Helpers
    module FormHelper
      def ui_text_field(name, value, url:, method: "POST", **options)
        Components::TextField.new(name, value, url: url, method: method, **options).render_in(self)
      end

      def ui_field(label, **options, &block)
        Components::Field.new(label, options, &block).render_in(self)
      end

      def ui_pill(text, **options)
        Components::Pill.new(text, options).render_in(self)
      end
    end
  end
end
