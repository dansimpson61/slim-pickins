# frozen_string_literal: true

module SlimPickins
  # Serves CSS/JS assets from the gem's assets directory
  module AssetServer
    def self.registered(app)
      # Get the gem's root directory
      gem_root = File.expand_path('../..', __dir__)
      assets_path = File.join(gem_root, 'assets')
      
      # Debug logging
      app.configure :development do
        puts "🍞 SlimPickins AssetServer initialized"
        puts "   Gem root: #{gem_root}"
        puts "   Assets path: #{assets_path}"
        puts "   Assets exist? #{File.directory?(assets_path)}"
      end
      
      # Serve assets
      app.get '/slim-pickins/assets/*' do
        # Get requested file path
        requested_path = params['splat'].first
        file_path = File.join(assets_path, requested_path)
        
        # Security: prevent directory traversal
        unless file_path.start_with?(assets_path)
          halt 403, 'Forbidden'
        end
        
        # Check if file exists
        unless File.exist?(file_path) && File.file?(file_path)
          halt 404, "File not found: #{requested_path}"
        end
        
        # Determine content type
        mime_type = case File.extname(requested_path)
          when '.css' then 'text/css'
          when '.js' then 'application/javascript'
          when '.map' then 'application/json'
          else 'application/octet-stream'
        end
        
        # Serve the file (send_file handles content-type)
        send_file file_path, type: mime_type, disposition: nil
      end
    end
  end
end
