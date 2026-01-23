require_relative 'flow'
require 'date'

class Projection
  attr_reader :start_balance, :start_date

  def initialize(ledger:, recurring_flows:, start_date: Date.today)
    @ledger = ledger
    @recurring_flows = recurring_flows
    @start_date = start_date
    @start_balance = @ledger.balance(1) # Main Portfolio
  end

  def build(period_in_months: 12)
    end_date = (@start_date >> period_in_months) - 1
    
    # 1. Gather all predicted flows from all rules
    all_future_flows = @recurring_flows.flat_map do |rule|
      rule.projection_between(@start_date, end_date)
    end.sort_by(&:date)

    # 2. Build the running balance timeline for Main Portfolio (ID 1)
    running_balance = @start_balance
    timeline = []

    all_future_flows.each do |flow|
      # Calculate impact on Main Portfolio
      impact = flow.value_for(1)
      
      # We only track flows that affect the Main Portfolio
      next if impact == 0
      
      running_balance += impact
      timeline << {
        date: flow.date,
        amount: impact, # Signed amount for display
        balance: running_balance,
        description: flow.description,
        type: flow.type_for(1)
      }
    end

    timeline
  end
end
