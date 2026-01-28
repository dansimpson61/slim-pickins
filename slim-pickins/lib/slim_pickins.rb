# frozen_string_literal: true

require_relative "slim_pickins/version"

module SlimPickins
  # Autoload helpers to keep startup fast
  autoload :Helpers, File.expand_path("slim_pickins/helpers", __dir__)

  autoload :AssetMiddleware, File.expand_path("slim_pickins/middleware/asset_middleware", __dir__)

  def self.registered(app)
    app.use AssetMiddleware
    app.helpers Helpers
  end
end
