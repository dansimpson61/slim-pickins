# frozen_string_literal: true

require "ostruct"
require "sinatra"
require "slim"
require_relative "lib/slim_pickins"

class App < Sinatra::Base
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

  # POST endpoint for inline edits
  post "/todos/:id" do
    content_type :json
    # In a real app, update DB here
    { status: "success", value: params[:value] }.to_json
  end

  # POST endpoint for sorting
  post "/todos/sort" do
    content_type :json
    # params[:ids] would be the new order
    { status: "success" }.to_json
  end

  run! if app_file == $0
end
