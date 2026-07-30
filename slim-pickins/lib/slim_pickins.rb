# frozen_string_literal: true

require "slim"
require_relative "slim_pickins/version"
require_relative "slim_pickins/safe_string"

module SlimPickins
  # Autoload helpers to keep startup fast
  autoload :Helpers, File.expand_path("slim_pickins/helpers", __dir__)

  autoload :AssetMiddleware, File.expand_path("slim_pickins/middleware/asset_middleware", __dir__)

  def self.registered(app)
    app.use AssetMiddleware
    app.helpers Helpers

    # One source of truth for escaping: the value, not the sigil.
    # With this on, Slim's `=` escapes a plain String and leaves a SafeString
    # alone, so `=` is the right call for markup and data alike. `==` remains
    # for the one place a value cannot carry its own safety: `== yield`.
    Slim::Engine.set_options(use_html_safe: true)
  end
end
