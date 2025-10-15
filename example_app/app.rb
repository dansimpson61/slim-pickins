# frozen_string_literal: true

require 'sinatra/base'
require_relative '../lib/slim_pickins'
require_relative 'models/todo'

class ExampleApp < Sinatra::Base
  register SlimPickins
  
  set :views, File.join(__dir__, 'views')
  set :public_folder, File.join(__dir__, 'public')
  
  # Home - show all todos
  get '/' do
    @todos = Todo.all
    @active_count = Todo.active.count
    slim :index
  end
  
  # Create new todo
  post '/todos' do
    Todo.create(
      title: params[:title],
      description: params[:description]
    )
    redirect '/'
  end
  
  # Toggle todo completion
  post '/todos/:id/toggle' do
    todo = Todo.find(params[:id].to_i)
    todo.toggle_complete! if todo
    redirect '/'
  end
  
  # Delete todo
  delete '/todos/:id' do
    Todo.delete(params[:id].to_i)
    redirect '/'
  end
  
  # Search todos
  get '/search' do
    query = params[:q]
    @todos = Todo.search(query)
    slim :partials/_todo_list, layout: false
  end
end
