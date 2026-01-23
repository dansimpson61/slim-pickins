require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/json'
require 'sqlite3'
require 'slim'
require 'date'

# Require Domain Model
require_relative 'lib/frequency'
require_relative 'lib/movement'
require_relative 'lib/recurring_movement'
require_relative 'lib/ledger'
require_relative 'lib/projection'

set :public_folder, 'public'

def ledger
  @ledger ||= Ledger.new
end

# Hardcoded rules for MVP demonstration
# In a real app, these would be stored in a 'recurring_movements' table
def sample_recurring_movements
  [
    RecurringMovement.new(
      frequency: Frequency.monthly(on: 1),
      base_amount: 5000.0,
      description: "Salary",
      start_date: Date.today - 365
    ),
    RecurringMovement.new(
      frequency: Frequency.monthly(on: 1),
      base_amount: -2200.0,
      description: "Mortgage",
      start_date: Date.today - 365,
      end_date: Date.today + (365 * 25) # 25 years left
    ),
    RecurringMovement.new(
      frequency: Frequency.weekly(on: :friday),
      base_amount: -150.0,
      description: "Groceries",
      start_date: Date.today - 30
    ),
    RecurringMovement.new(
      frequency: Frequency.monthly(on: 15),
      base_amount: -100.0,
      description: "Utilities",
      start_date: Date.today - 30
    ),
    # A one-off vacation in 3 months
    RecurringMovement.new(
      frequency: Frequency.once(on: Date.today + 90),
      base_amount: -3000.0,
      description: "Island Vacation",
      start_date: Date.today
    )
  ]
end

get '/' do
  # Fetch Portfolio Balance (from Ledger)
  # Note: The original 'portfolio' table had a separate balance. 
  # Ideally, 'balance' is the sum of the ledger. 
  # For now, we'll align the view variable @portfolio to look like the old struct 
  # or simply pass @balance.
  
  @balance = ledger.balance
  # Retrieve portfolio name or config if needed, for now just hardcode or use simple struct
  @portfolio = { 'name' => "Main Portfolio", 'balance' => @balance }

  # Fetch Recent Movements
  @movements = ledger.recent(5).map(&:to_h)
  
  slim :index
end

# API Endpoint to create a movement
post '/movements' do
  data = JSON.parse(request.body.read)
  
  # Map JSON to Movement object
  movement = Movement.new(
    amount: data['amount'].to_f,
    date: Date.parse(data['date']),
    description: data['description'],
    type: nil, # inferred
    tax_info: {
      is_taxable: data['is_taxable'],
      federal_tax_rate: data['federal_tax_rate'],
      state_tax_rate: data['state_tax_rate']
    }
  )
  
  ledger.add(movement)
  
  json status: 'success'
end

delete '/movements/:id' do
  ledger.delete(params[:id])
  json status: 'success'
end

put '/movements/:id' do
  data = JSON.parse(request.body.read)
  
  movement = Movement.new(
    id: params[:id],
    amount: data['amount'].to_f,
    date: Date.parse(data['date']),
    description: data['description'],
    type: nil, # inferred
    tax_info: {
      is_taxable: data['is_taxable'],
      federal_tax_rate: data['federal_tax_rate'],
      state_tax_rate: data['state_tax_rate']
    }
  )
  
  ledger.update(params[:id], movement)
  json status: 'success'
end

# API Endpoint for Chart Data (Projected)
get '/api/projection' do
  # Build projection
  projection = Projection.new(
    ledger: ledger, 
    recurring_movements: sample_recurring_movements,
    start_date: Date.today
  )
  
  # Get 1 year of data
  timeline = projection.build(period_in_months: 12)
  
  # Transform for frontend chart (labels: date, data: balance)
  # We might want to sample this if it's too daily? 
  # For now, let's just return key points (daily balance).
  
  # Group by month for a cleaner chart? Or just return daily?
  # Let's return daily points where events happen.
  
  data = timeline.map do |entry|
    {
      year: entry[:date].to_s, # Frontend expects 'year' or 'date'? Old code used 'year' (int). Let's stick to date string.
      balance: entry[:balance],
      label: entry[:date].strftime("%b %d") # For tooltip
    }
  end
  
  json data
end
