require_relative 'flow'
require 'date'

class Projection
  attr_reader :start_balance, :start_date

  # Now accepts a list of account_ids to simulate as a group (Portfolio)
  def initialize(ledger:, recurring_flows:, account_ids: [1], start_date: Date.today)
    @ledger = ledger
    @recurring_flows = recurring_flows
    @account_ids = account_ids
    @start_date = start_date
    
    # Start balance is the sum of all tracked accounts
    @start_balance = @account_ids.sum { |id| @ledger.balance(id) }
  end

  def build(period_in_months: 12)
    end_date = (@start_date >> period_in_months) - 1
    
    # 1. Gather all predicted flows from all rules
    all_future_flows = @recurring_flows.flat_map do |rule|
      rule.projection_between(@start_date, end_date)
    end.sort_by(&:date)

    # 2. Build the running balance timeline
    running_balance = @start_balance
    timeline = []

    all_future_flows.each do |flow|
      # Calculate net impact on the Portfolio (Aggregation of Accounts)
      # If flow is internal (between two accounts in the set), impact is 0.
      # If flow is external (one in, one out), impact is +/- amount.
      impact = @account_ids.sum { |id| flow.value_for(id) }
      
      # We only track flows that affect the Portfolio balance
      next if impact == 0
      
      running_balance += impact
      
      # Determine type for the portfolio view
      type = :neutral
      if impact > 0
        type = :inflow
      elsif impact < 0
        type = :outflow
      end

      timeline << {
        date: flow.date,
        amount: impact,
        balance: running_balance,
        description: flow.description,
        type: type
      }
    end

    timeline
  end
end
