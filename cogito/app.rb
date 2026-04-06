require 'sinatra/base'
require 'slim'

module JoyfulPuzzles
  class App < Sinatra::Base
    set :public_folder, 'public'
    set :views, 'views'
    
    get '/' do
      slim :index
    end

    get '/tango' do
      require_relative 'lib/domain/tango/generator'
      seed = params[:random] ? Random.new_seed : Date.today.yday
      @grid = Tango::Generator.new(seed: seed).generate(size: 6)
      slim :tango
    end

    get '/queens' do
      require_relative 'lib/domain/queens/generator'
      seed = params[:random] ? Random.new_seed : Date.today.yday
      @grid = Queens::Generator.new(seed: seed).generate(size: 8)
      slim :queens
    end

    post '/tango/validate' do
      require 'json'
      require_relative 'lib/domain/tango/grid'
      require_relative 'lib/domain/tango/validator'
      
      data = JSON.parse(request.body.read)
      initial_state = data['cells'].map { |row| row.map(&:to_sym) }
      grid = Tango::Grid.new(size: data['size'], initial_state: initial_state, constraints: data['constraints'].map { |c| { type: c['type'].to_sym, cells: c['cells'] } })
      
      validator = Tango::Validator.new(grid)
      content_type :json
      { valid: validator.valid?, complete: validator.complete_and_valid? }.to_json
    end

    post '/queens/validate' do
      require 'json'
      require_relative 'lib/domain/queens/grid'
      require_relative 'lib/domain/queens/validator'
      
      data = JSON.parse(request.body.read)
      size = data['size']
      
      # Transform regions into expected region_map
      region_map = Array.new(size) { Array.new(size, 0) }
      data['cells'].each_with_index do |row, r|
        row.each_with_index do |cell_data, c|
          region_map[r][c] = cell_data['region_id']
        end
      end
      
      grid = Queens::Grid.new(size: size, region_map: region_map)
      
      # apply queens
      data['cells'].each_with_index do |row, r|
        row.each_with_index do |cell_data, c|
          grid.cell_at(r, c).has_queen = cell_data['has_queen']
        end
      end
      
      validator = Queens::Validator.new(grid)
      content_type :json
      { valid: validator.valid?, complete: validator.complete_and_valid? }.to_json
    end
  end
end
