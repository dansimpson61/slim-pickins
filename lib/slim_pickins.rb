# frozen_string_literal: true

require 'sinatra/base'
require 'slim'

require_relative 'slim_pickins/version'
require_relative 'slim_pickins/helpers'

module SlimPickins
  def self.registered(app)
    app.helpers SlimPickins::Helpers
    app.configure do
      Slim::Engine.set_options(
        pretty: app.development?,
        sort_attrs: false
      )
    end
  end
end
