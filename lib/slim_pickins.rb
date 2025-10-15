# frozen_string_literal: true

require 'sinatra/base'
require 'slim'

require_relative 'slim_pickins/version'
require_relative 'slim_pickins/helpers'
require_relative 'slim_pickins/asset_server'

module SlimPickins
  def self.registered(app)
    # Register helpers
    app.helpers SlimPickins::Helpers
    
    # Register asset server
    app.register SlimPickins::AssetServer
    
    # Configure Slim
    app.configure do
      Slim::Engine.set_options(
        pretty: app.development?,
        sort_attrs: false
      )
    end
  end
end
