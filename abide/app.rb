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
MAIN_ACCOUNT_ID = 1
EXTERNAL_ID = 2
MARKET_ID = 3

# Portfolio IDs
DEFAULT_PORTFOLIO_ID = 1

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
      destination_id: MAIN_ACCOUNT_ID,
      start_date: Date.today - 365
    ),
    RecurringFlow.new(
      frequency: Frequency.monthly(on: 1),
      base_amount: 2200.0,
      description: "Mortgage",
      source_id: MAIN_ACCOUNT_ID,
      destination_id: EXTERNAL_ID,
      start_date: Date.today - 365,
      end_date: Date.today + (365 * 25)
    ),
    RecurringFlow.new(
      frequency: Frequency.weekly(on: :friday),
      base_amount: 150.0,
      description: "Groceries",
      source_id: MAIN_ACCOUNT_ID, 
      destination_id: EXTERNAL_ID,
      start_date: Date.today - 30
    ),
    RecurringFlow.new(
      frequency: Frequency.monthly(on: 15),
      base_amount: 100.0,
      description: "Utilities",
      source_id: MAIN_ACCOUNT_ID,
      destination_id: EXTERNAL_ID,
      start_date: Date.today - 30
    ),
    RecurringFlow.new(
      frequency: Frequency.once(on: Date.today + 90),
      base_amount: 3000.0,
      description: "Island Vacation",
      source_id: MAIN_ACCOUNT_ID,
      destination_id: EXTERNAL_ID,
      start_date: Date.today
    )
  ]
end

get '/' do
  # Determine Portfolio View
  portfolio_id = params[:portfolio_id] ? params[:portfolio_id].to_i : DEFAULT_PORTFOLIO_ID
  
  # Fetch Balance for View
  @balance = ledger.portfolio_balance(portfolio_id)
  
  # Fetch Metadata for View
  portfolios = ledger.get_portfolios
  current_portfolio_name = portfolios.find { |p| p['id'] == portfolio_id }['name'] rescue "Unknown"
  
  @portfolio = { 'id' => portfolio_id, 'name' => current_portfolio_name, 'balance' => @balance }
  @portfolios = portfolios

  # Fetch Recent Flows (filtered for View)
  # Ideally ledger.recent should take a portfolio_id or list of accounts.
  # For now, we simplify: if Default, show Account 1. Otherwise show nothing (TODO: Update Ledger#recent)
  # Actually, let's fix this properly.
  account_urls = ledger.get_portfolio_accounts(portfolio_id)
  if account_urls.any?
    # Hack: just check the first account for now since Ledger#recent is single-account
    # This is a known limitation we accepted in this iteration.
    target_account = account_urls.first['id']
    @movements = ledger.recent(10, target_account).map do |flow|
      {
        'id' => flow.id,
        'amount' => flow.value_for(target_account),
        'date' => flow.date,
        'description' => flow.description,
        'type' => flow.type_for(target_account),
        'tax_info' => flow.tax_info
      }
    end
  else
    @movements = []
  end
  
  slim :index
end



get '/accounts' do
  # Support ?show_archived=true
  include_archived = params[:show_archived] == 'true'
  @accounts = ledger.get_accounts(include_archived: include_archived)
  @ledger = ledger # Pass ledger instance to view for balance calc
  slim :accounts
end

# API: Accounts CRUD
post '/accounts' do
  data = JSON.parse(request.body.read)
  id = ledger.create_account(data['name'], data['type'])
  json status: 'success', id: id
end

put '/accounts/:id' do
  data = JSON.parse(request.body.read)
  # Ideally fetch existing type/name if only one is passed, but for inline edit we expect full object or we handle partials?
  # Ledger#update_account requires both currently.
  # Let's simple fetch current state first to support partial updates
  current = ledger.get_accounts(include_archived: true).find { |a| a['id'] == params[:id].to_i }
  if current
    name = data['name'] || current['name']
    type = data['type'] || current['type']
    ledger.update_account(params[:id], name, type)
    json status: 'success'
  else
    status 404
  end
end

put '/accounts/:id/archive' do
  ledger.archive_account(params[:id])
  json status: 'success'
end

put '/accounts/:id/restore' do
  ledger.restore_account(params[:id])
  json status: 'success'
end

delete '/accounts/:id' do
  begin
    ledger.delete_account(params[:id])
    json status: 'success'
  rescue => e
    status 400
    json status: 'error', message: e.message
  end
end

get '/portfolios/manage' do
  @portfolios = ledger.get_portfolios
  @accounts = ledger.get_accounts
  @ledger = ledger
  slim :portfolios
end

# API: Portfolios Management
get '/portfolios' do
  json ledger.get_portfolios
end

post '/portfolios' do
  data = JSON.parse(request.body.read)
  id = ledger.create_portfolio(data['name'])
  json status: 'success', id: id
end

put '/portfolios/:id' do
  data = JSON.parse(request.body.read)
  # Ledger doesn't have update_portfolio yet? 
  # Wait, we need to add update_portfolio to Ledger or do direct DB.
  # Let's add it via DB exec here or add to ledger.rb.
  # Adding to ledger.rb is cleaner but for speed/simplicity inline for now:
  ledger.instance_variable_get(:@db).execute("UPDATE portfolios SET name = ? WHERE id = ?", [data['name'], params[:id]])
  json status: 'success'
end

delete '/portfolios/:id' do
  ledger.delete_portfolio(params[:id])
  json status: 'success'
end

post '/portfolios/:id/accounts' do
  ledger.add_account_to_portfolio(params[:id], params['account_id'])
  json status: 'success'
end

# API Endpoint to create a movement (Flow)
post '/movements' do
  data = JSON.parse(request.body.read)
  
  amount = data['amount'].to_f
  
  # Infer Source/Dest from Signed Amount (Legacy UI support)
  if amount >= 0
    source = EXTERNAL_ID
    dest = MAIN_ACCOUNT_ID
  else
    source = MAIN_ACCOUNT_ID
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
    dest = MAIN_ACCOUNT_ID
  else
    source = MAIN_ACCOUNT_ID
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
  portfolio_id = params[:portfolio_id] || DEFAULT_PORTFOLIO_ID
  
  # 1. Get Accounts in this Portfolio
  accounts = ledger.get_portfolio_accounts(portfolio_id)
  account_ids = accounts.map { |a| a['id'] }
  
  projection = Projection.new(
    ledger: ledger, 
    recurring_flows: sample_recurring_flows,
    account_ids: account_ids,
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
