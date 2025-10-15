# frozen_string_literal: true

require 'sinatra/base'
require_relative '../lib/slim_pickins'

class SamplerApp < Sinatra::Base
  register SlimPickins
  
  set :views, File.join(__dir__, 'views')
  set :public_folder, File.join(__dir__, 'public')
  
  # Home
  get '/' do
    slim :index
  end
  
  # Component pages
  get '/components' do
    slim :'pages/components'
  end
  
  get '/patterns' do
    slim :'pages/patterns'
  end
  
  get '/forms' do
    slim :'pages/forms'
  end
  
  get '/stimulus' do
    slim :'pages/stimulus'
  end
  
  # Demo endpoints
  post '/demo/submit' do
    redirect '/forms?success=true'
  end
  
  get '/demo/search' do
    query = params[:q] || ""
    # FIX: Use instance variable so partial can access it
    @results = ["Apple", "Banana", "Cherry", "Date"].select { |f| f.downcase.include?(query.downcase) }
    slim :'partials/_search_results', layout: false
  end
end
