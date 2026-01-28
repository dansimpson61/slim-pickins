# frozen_string_literal: true

module SlimPickins
  # A simple Rack middleware to serve Slim-Pickins assets
  # directly from the gem, avoiding manual copying.
  class AssetMiddleware
    def initialize(app, path: "/assets")
      @app = app
      @prefix = path
      @root = File.expand_path("../../../assets", __dir__)
      @file_server = Rack::Files.new(@root)
    end

    def call(env)
      path = env["PATH_INFO"]
      
      if path.start_with?(@prefix)
        # Strip prefix and serve file
        # e.g. /assets/stylesheets/slim-pickins.css -> stylesheets/slim-pickins.css
        req_path = path.sub(@prefix, "")
        
        # Security check: ensure no directory traversal
        if req_path.include?("..")
          return [403, { "Content-Type" => "text/plain" }, ["Forbidden"]]
        end
        
        # Pass to Rack::File
        env["PATH_INFO"] = req_path
        @file_server.call(env)
      else
        @app.call(env)
      end
    end
  end
end
