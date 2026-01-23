require_relative 'movement'
require 'date'

class Projection
  attr_reader :start_balance, :start_date

  def initialize(ledger:, recurring_movements:, start_date: Date.today)
    @ledger = ledger
    @recurring_movements = recurring_movements
    @start_date = start_date
    @start_balance = @ledger.balance
  end

  def build(period_in_months: 12)
    # Subtract 1 day to make the range [start, end) relative to the next period start
    # e.g. Jan 1 + 3 months = Apr 1. We want Jan 1..Mar 31.
    end_date = (@start_date >> period_in_months) - 1
    
    # 1. Gather all predicted movements from all rules
    all_future_movements = @recurring_movements.flat_map do |rule|
      rule.projection_between(@start_date, end_date)
    end.sort_by(&:date)

    # 2. Build the running balance timeline
    running_balance = @start_balance
    timeline = []

    # Optional: We could emit daily points, or just movement points.
    # Let's emit points for every movement.
    
    all_future_movements.each do |mv|
      running_balance += mv.amount
      timeline << {
        date: mv.date,
        amount: mv.amount,
        balance: running_balance,
        description: mv.description,
        type: mv.type
      }
    end

    timeline
  end
end
