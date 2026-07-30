# frozen_string_literal: true

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

    # Controllers not yet migrated to components. This list only shrinks; when
    # it is empty the restructuring is finished.
    LEGACY_CONTROLLERS = {
      "sp-inline-edit" => "js/controllers/sp_inline_edit_controller.js",
      "sp-sortable"    => "js/controllers/sp_sortable_controller.js",
      "sp-modal"       => "js/controllers/sp_modal_controller.js"
    }.freeze

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

      return respond("text/css", stylesheet)        if req_path == STYLESHEET
      return respond("text/javascript", behaviour)  if req_path == BEHAVIOUR
      return forbidden                              if req_path.include?("..")

      env["PATH_INFO"] = req_path
      @file_server.call(env)
    end

    private

    def respond(type, body)
      [200, { "content-type" => type, "content-length" => body.bytesize.to_s }, [body]]
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
      components = Component.registry.select(&:needs_controller?)

      imports = components.each_with_index.map { |c, i|
        %(import C#{i} from "#{@prefix}/#{c.behaviour}")
      }
      legacy = LEGACY_CONTROLLERS.keys.each_with_index.map { |_, i|
        %(import L#{i} from "#{@prefix}/#{LEGACY_CONTROLLERS.values[i]}")
      }
      entries = components.each_with_index.map { |c, i| %(  "#{c.controller}": C#{i}) } +
                LEGACY_CONTROLLERS.keys.each_with_index.map { |id, i| %(  "#{id}": L#{i}) }

      <<~JS
        // Generated from Component.registry. Do not edit.
        #{(imports + legacy).join("\n")}

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
