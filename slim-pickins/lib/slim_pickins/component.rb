# frozen_string_literal: true

require_relative "safe_string"
require_relative "rendering"

module SlimPickins
  # A component is one object that knows its own name.
  #
  # The name is declared once -- by the class -- and everything else is derived
  # from it: the CSS class it renders, the Stimulus controller that drives it,
  # and the two asset files that hold its appearance and its behaviour. Nothing
  # is retyped in a second file, so nothing can drift out of agreement.
  #
  #   class Flash < Component
  #     needs_controller
  #     def render = tag(:div, @message, class: base_class(@variant), ...)
  #   end
  #
  #   Flash.slug        # => "flash"
  #   Flash.css_class   # => "sp-flash"
  #   Flash.controller  # => "sp-flash"
  #   Flash.stylesheet  # => "components/flash.css"
  #   Flash.behaviour   # => "components/flash.js"
  #
  # Templates never see this. A helper is the façade:
  #
  #   = ui_flash :notice, "Welcome"
  class Component
    include Rendering

    class << self
      # Every subclass enrols itself, so the library can enumerate what it has
      # and assert that each part is present.
      def registry = @registry ||= []

      def inherited(subclass)
        super
        Component.registry << subclass
      end

      # Derived from the class name by default. Declare it explicitly only to
      # keep an established name -- `slug "btn"` rather than renaming .sp-btn
      # across every view. Either way it is written once, in this file, and
      # everything else follows from it.
      def slug(explicit = nil)
        @slug = explicit if explicit
        @slug ||= name.split("::").last
                      .gsub(/([a-z\d])([A-Z])/, '\1-\2')
                      .downcase
      end

      def css_class  = "sp-#{slug}"
      def stylesheet = "components/#{slug}.css"
      def behaviour  = needs_controller? ? "components/#{slug}.js" : nil
      def controller = needs_controller? ? css_class : nil

      # Declares that this component's markup is driven by a Stimulus
      # controller. The identifier is the CSS class; there is no second name.
      def needs_controller = @needs_controller = true
      def needs_controller? = !!@needs_controller
    end

    private

    # "sp-flash", plus "sp-flash--notice" for each modifier given.
    def base_class(*modifiers)
      [self.class.css_class,
       *modifiers.compact.map { |m| "#{self.class.css_class}--#{m}" }]
    end

    # An element inside this component: "sp-flash__body".
    def element_class(part) = "#{self.class.css_class}__#{part}"

    # Merges this component's controller into a data hash, if it has one.
    def with_controller(data = {})
      self.class.controller ? data.merge(controller: self.class.controller) : data
    end
  end
end
