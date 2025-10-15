# frozen_string_literal: true

require 'sinatra/base'
require 'slim'
require 'json'

$LOAD_PATH.unshift File.expand_path('../../lib', __dir__)
require 'slim_pickins'
require 'slim_pickins/asset_server'

class DemoApp < Sinatra::Base
  register SlimPickins
  register SlimPickins::AssetServer  # Serve CSS from gem
  
  set :views, File.expand_path('views', __dir__)
  set :public_folder, File.expand_path('public', __dir__)
  
  configure :development do
    set :logging, true
  end
  
  # Calculation model
  class Calculation
    attr_accessor :principal, :rate, :years
    
    def initialize(principal: 10000, rate: 7.0, years: 10)
      @principal = principal.to_f
      @rate = rate.to_f
      @years = years.to_i
    end
    
    def final_amount
      principal * (1 + rate / 100) ** years
    end
    
    def interest
      final_amount - principal
    end
    
    def annual_growth
      interest / years
    end
    
    # Historical data for sparkline demo
    def year_by_year
      (0..years).map do |year|
        value = principal * (1 + rate / 100) ** year
        { year: year, amount: value }
      end
    end
    
    def to_h
      {
        principal: principal,
        rate: rate,
        years: years
      }
    end
  end
  
  # Home page with calculator
  get '/' do
    @calc = Calculation.new
    slim :index
  end
  
  # Reactive endpoint - receives JSON, returns HTML fragment
  post '/calculate' do
    content_type :html
    
    puts "📥 POST /calculate received"
    
    request.body.rewind
    body = request.body.read
    puts "📊 Request body: #{body}"
    
    data = JSON.parse(body)
    puts "✅ Parsed JSON: #{data.inspect}"
    
    @calc = Calculation.new(
      principal: data['principal'],
      rate: data['rate'],
      years: data['years']
    )
    
    puts "💰 Calculated:"
    puts "   Principal: $#{@calc.principal}"
    puts "   Rate: #{@calc.rate}%"
    puts "   Years: #{@calc.years}"
    puts "   Final: $#{'%.2f' % @calc.final_amount}"
    
    result = slim :_results, layout: false
    puts "📤 Sending HTML response (#{result.length} bytes)"
    result
  end
  
  # Examples page
  get '/examples' do
    @calc = Calculation.new(principal: 25000, rate: 8.5, years: 15)
    slim :examples
  end
end
