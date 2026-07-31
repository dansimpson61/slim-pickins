# frozen_string_literal: true

require "slim"
require_relative "slim_pickins/version"
require_relative "slim_pickins/safe_string"
require_relative "slim_pickins/rendering"
require_relative "slim_pickins/component"
require_relative "slim_pickins/word"
require_relative "slim_pickins/collection"
require_relative "slim_pickins/tabular"
require_relative "slim_pickins/grammar"

module SlimPickins
  # Every file in components/ enrols itself in Component.registry simply by
  # existing. That registry is what drives the stylesheet, the controller
  # registration, and the completeness audit -- so adding a component is one
  # file, not an entry in three lists.
  Dir[File.expand_path("slim_pickins/components/*.rb", __dir__)].sort.each do |file|
    require file
  end

  autoload :Helpers, File.expand_path("slim_pickins/helpers", __dir__)
  autoload :AssetMiddleware, File.expand_path("slim_pickins/middleware/asset_middleware", __dir__)

  # Components whose appearance or behaviour is missing.
  #
  # A component declares what it needs; this checks the files are actually
  # there. It is the check that would have caught .sp-flash and
  # .sp-toggle-panel rendering unstyled for weeks.
  def self.audit
    root = File.expand_path("../assets", __dir__)

    Component.registry.filter_map do |component|
      missing = []
      css = File.join(root, component.stylesheet)
      missing << component.stylesheet unless File.exist?(css) && File.read(css).include?(".#{component.css_class}")

      if component.needs_controller?
        js = File.join(root, component.behaviour)
        missing << component.behaviour unless File.exist?(js)
      end

      { component: component, missing: missing } unless missing.empty?
    end
  end

  def self.registered(app)
    app.use AssetMiddleware
    app.helpers Helpers

    # One source of truth for escaping: the value, not the sigil.
    # With this on, Slim's `=` escapes a plain String and leaves a SafeString
    # alone, so `=` is the right call for markup and data alike. `==` remains
    # for the one place a value cannot carry its own safety: `== yield`.
    Slim::Engine.set_options(use_html_safe: true)

    # Spoken vocabulary is resolved against the parse tree, before Slim has
    # decided that `navigation` is an unknown HTML element.
    unless Slim::Engine.chain.any? { |step| step[0].to_s == Grammar.name }
      Slim::Engine.after(Slim::Parser, Grammar)
    end
  end
end
