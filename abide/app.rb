require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/json'
require 'sqlite3'
require 'slim'
require 'date'

# Require Domain Model
require_relative 'lib/frequency'
require_relative 'lib/flow'
require_relative 'lib/recurring_flow'
require_relative 'lib/ledger'
require_relative 'lib/projection'

# Account IDs
MAIN_PORTFOLIO_ID = 1
EXTERNAL_ID = 2
MARKET_ID = 3

set :public_folder, 'public'

def ledger
  @ledger ||= Ledger.new
end

# Hardcoded rules for MVP demonstration
def sample_recurring_flows
  [
    RecurringFlow.new(
      frequency: Frequency.monthly(on: 1),
      base_amount: 5000.0,
      description: "Salary",
      source_id: EXTERNAL_ID,
      destination_id: MAIN_PORTFOLIO_ID,
      start_date: Date.today - 365
    ),
    RecurringFlow.new(
      frequency: Frequency.monthly(on: 1),
      base_amount: 2200.0,
      description: "Mortgage",
      source_id: MAIN_PORTFOLIO_ID,
      destination_id: EXTERNAL_ID,
      start_date: Date.today - 365,
      end_date: Date.today + (365 * 25)
    ),
    RecurringFlow.new(
      frequency: Frequency.weekly(on: :friday),
      base_amount: 150.0,
      description: "Groceries",
      source_id: MAIN_PORTFOLIO_ID, 
      destination_id: EXTERNAL_ID,
      start_date: Date.today - 30
    ),
    RecurringFlow.new(
      frequency: Frequency.monthly(on: 15),
      base_amount: 100.0,
      description: "Utilities",
      source_id: MAIN_PORTFOLIO_ID,
      destination_id: EXTERNAL_ID,
      start_date: Date.today - 30
    ),
    RecurringFlow.new(
      frequency: Frequency.once(on: Date.today + 90),
      base_amount: 3000.0,
      description: "Island Vacation",
      source_id: MAIN_PORTFOLIO_ID,
      destination_id: EXTERNAL_ID,
      start_date: Date.today
    )
  ]
end

get '/' do
  # Fetch Balance for Main Portfolio
  @balance = ledger.balance(MAIN_PORTFOLIO_ID)
  @portfolio = { 'name' => "Main Portfolio", 'balance' => @balance }

  # Fetch Recent Flows (filtered for Main Portfolio)
  @movements = ledger.recent(10, MAIN_PORTFOLIO_ID).map do |flow|
    # Map back to a UI-friendly hash with signed amount relative to Main
    {
      'id' => flow.id,
      'amount' => flow.value_for(MAIN_PORTFOLIO_ID),
      'date' => flow.date,
      'description' => flow.description,
      'type' => flow.type_for(MAIN_PORTFOLIO_ID),
      'tax_info' => flow.tax_info
    }
  end
  
  slim :index
end

# API Endpoint to create a movement (Flow)
post '/movements' do
  data = JSON.parse(request.body.read)
  
  amount = data['amount'].to_f
  
  # Infer Source/Dest from Signed Amount (Legacy UI support)
  if amount >= 0
    source = EXTERNAL_ID
    dest = MAIN_PORTFOLIO_ID
  else
    source = MAIN_PORTFOLIO_ID
    dest = EXTERNAL_ID
  end

  flow = Flow.new(
    amount: amount,
    date: Date.parse(data['date']),
    description: data['description'],
    source_id: source,
    destination_id: dest,
    tax_info: {
      is_taxable: data['is_taxable'],
      federal_tax_rate: data['federal_tax_rate'],
      state_tax_rate: data['state_tax_rate']
    }
  )
  
  ledger.add(flow)
  
  json status: 'success'
end

delete '/movements/:id' do
  ledger.delete(params[:id])
  json status: 'success'
end

put '/movements/:id' do
  data = JSON.parse(request.body.read)
  
  amount = data['amount'].to_f
  
  # Infer Source/Dest (Legacy UI support)
  if amount >= 0
    source = EXTERNAL_ID
    dest = MAIN_PORTFOLIO_ID
  else
    source = MAIN_PORTFOLIO_ID
    dest = EXTERNAL_ID
  end
  
  flow = Flow.new(
    id: params[:id],
    amount: amount,
    date: Date.parse(data['date']),
    description: data['description'],
    source_id: source,
    destination_id: dest,
    tax_info: {
      is_taxable: data['is_taxable'],
      federal_tax_rate: data['federal_tax_rate'],
      state_tax_rate: data['state_tax_rate']
    }
  )
  
  ledger.update(params[:id], flow)
  json status: 'success'
end

# API Endpoint to update Market Value (Valuation)
# User says: "Account X is worth $Y on Date Z"
# We calculate: Delta = Y - Current_Balance
# We create: Flow from/to Market
post '/accounts/:id/valuation' do
  account_id = params[:id].to_i
  data = JSON.parse(request.body.read)
  
  target_value = data['value'].to_f
  date = Date.parse(data['date'])
  
  # 1. Get current balance
  # Note: Ideally we want balance *at that date*, but for simplicity we'll use current balance 
  # OR we assume this is a "Mark to Market" event for "Now".
  # If the user is backdating, we should probably check balance at that date, 
  # but `ledger.balance` is currently "all time". 
  # Let's assume the user is updating the *current* state.
  current_balance = ledger.balance(account_id)
  
  delta = target_value - current_balance
  
  if delta.abs < 0.01
    return json status: 'skipped', message: 'Value unchanged'
  end
  
  if delta > 0
    # Appreciation: Market -> Account
    source = MARKET_ID
    dest = account_id
    desc = "Market Adjustment (Appreciation)"
  else
    # Depreciation: Account -> Market
    source = account_id
    dest = MARKET_ID
    desc = "Market Adjustment (Depreciation)"
  end
  
  flow = Flow.new(
    amount: delta.abs,
    date: date,
    description: desc,
    source_id: source,
    destination_id: dest
  )
  
  ledger.add(flow)
  
  json status: 'success', delta: delta, new_balance: target_value
end

# API Endpoint for Chart Data (Projected)
get '/api/projection' do
  projection = Projection.new(
    ledger: ledger, 
    recurring_flows: sample_recurring_flows,
    start_date: Date.today
  )
  
  timeline = projection.build(period_in_months: 12)
  
  data = timeline.map do |entry|
    {
      year: entry[:date].to_s,
      balance: entry[:balance],
      label: entry[:date].strftime("%b %d")
    }
  end
  
  json data
end
