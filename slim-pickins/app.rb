# frozen_string_literal: true

require "ostruct"
require "sinatra"
require "slim"
require_relative "lib/slim_pickins"

require "sinatra/capture"

class App < Sinatra::Base
  helpers Sinatra::Capture
  register SlimPickins

  set :public_folder, File.join(__dir__, "public")
  set :views, File.join(__dir__, "views")

  get "/" do
    # Simulate some data
    @todos = [
      { id: 1, title: "Buy Bread", done: false },
      { id: 2, title: "Walk the Dog", done: true },
      { id: 3, title: "Write Code", done: false }
    ]
    slim :index
  end

  # POST endpoint for inline edits. sp-inline-edit sends JSON keyed by the
  # field's name, so a route reads the field it asked for.
  post "/todos/:id" do
    content_type :json
    data = JSON.parse(request.body.read) rescue {}
    { status: "success", title: data["title"] }.to_json
  end

  # POST endpoint for sorting
  post "/todos/sort" do
    content_type :json
    # params[:ids] would be the new order
    { status: "success" }.to_json
  end

  # Documentation Routes
  get "/docs" do
    slim :"docs/index"
  end

  get "/docs/playground" do
    slim :"docs/playground"
  end

  get "/docs/quickstart" do
    slim :"docs/quickstart"
  end

  post "/docs/render" do
    # Render arbitrary Slim source from the playground
    slim params[:source], layout: false
  end

  get "/docs/:component" do
    begin
      slim :"docs/#{params[:component]}"
    rescue Errno::ENOENT
      halt 404, "Component documentation not found"
    end
  end

  get "/status" do
    slim :status
  end

  run! if app_file == $0
end
