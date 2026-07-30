# frozen_string_literal: true

require "digest"

module SlimPickins
  # Serves Slim-Pickins assets straight from the gem, so a consuming app copies
  # nothing and cannot drift.
  #
  # Two of the paths are assembled rather than read from disk. Both are built
  # by walking Component.registry, so adding a component file is the only step
  # needed to get its appearance and behaviour delivered -- there is no second
  # list to remember.
  class AssetMiddleware
    STYLESHEET = "/stylesheets/slim-pickins.css"
    BEHAVIOUR  = "/js/slim_pickins.js"

    def initialize(app, path: "/assets")
      @app = app
      @prefix = path
      @root = File.expand_path("../../../assets", __dir__)
      @file_server = Rack::Files.new(@root)
    end

    def call(env)
      path = env["PATH_INFO"].to_s
      return @app.call(env) unless path == @prefix || path.start_with?("#{@prefix}/")

      req_path = path.delete_prefix(@prefix)

      return respond("text/css", stylesheet, env)       if req_path == STYLESHEET
      return respond("text/javascript", behaviour, env) if req_path == BEHAVIOUR
      return forbidden                                  if req_path.include?("..")

      env["PATH_INFO"] = req_path
      @file_server.call(env)
    end

    private

    # Assembled assets still need cache validation. Without it the browser
    # re-downloads the stylesheet on every navigation, which shows up as a
    # flash of unstyled content between pages -- and, worse, gives it licence
    # to serve a stale copy of a module whose imports no longer exist.
    #
    # The ETag is a digest of the assembled body, so it changes exactly when a
    # component does. no-cache means "store it, but revalidate" -- every
    # navigation asks, and gets an instant 304 until something really changed.
    def respond(type, body, env)
      etag = %("#{Digest::SHA256.hexdigest(body)[0, 16]}")
      headers = { "etag" => etag, "cache-control" => "no-cache" }

      return [304, headers, []] if env["HTTP_IF_NONE_MATCH"] == etag

      [200, headers.merge("content-type" => type,
                          "content-length" => body.bytesize.to_s), [body]]
    end

    def forbidden
      [403, { "content-type" => "text/plain" }, ["Forbidden"]]
    end

    # Base styles, then every component's own stylesheet.
    def stylesheet
      parts = [read("stylesheets/slim-pickins.css")]
      Component.registry.each do |component|
        parts << "\n/* --- #{component.slug} --- */\n" << read(component.stylesheet)
      end
      parts.join
    end

    # An ES module that registers every controller the library owns.
    def behaviour
      components = Component.registry.select(&:needs_controller?).sort_by(&:slug)

      imports = components.each_with_index.map { |c, i|
        %(import C#{i} from "#{@prefix}/#{c.behaviour}")
      }
      entries = components.each_with_index.map { |c, i| %(  "#{c.controller}": C#{i}) }

      <<~JS
        // Generated from Component.registry. Do not edit.
        #{imports.join("\n")}

        export const controllers = {
        #{entries.join(",\n")}
        }

        export function registerSlimPickins(application) {
          for (const [identifier, controller] of Object.entries(controllers)) {
            application.register(identifier, controller)
          }
          return application
        }
      JS
    end

    def read(relative)
      file = File.join(@root, relative)
      File.exist?(file) ? File.read(file) : ""
    end
  end
end
