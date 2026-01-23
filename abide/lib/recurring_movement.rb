require_relative 'movement'
require_relative 'frequency'

class RecurringMovement
  attr_reader :frequency, :base_amount, :description, :start_date, :end_date

  def initialize(frequency:, base_amount:, description:, start_date:, end_date: nil)
    @frequency = frequency
    @base_amount = base_amount
    @description = description
    @start_date = start_date
    @end_date = end_date
  end

  # Returns an Array of predicted Movement objects falling strictly within the range
  def projection_between(range_start, range_end)
    # 1. Intersect the requested window with the Rule's Active Window
    effective_start = [range_start, @start_date].max
    
    effective_end = range_end
    effective_end = [effective_end, @end_date].min if @end_date
    
    return [] if effective_start > effective_end

    results = []
    
    # We need to find the first occurrence on or after effective_start
    # But Frequency#next_occurrence finds one *after* a date.
    # So we check if effective_start itself matches.
    
    search_head = effective_start - 1
    
    loop do
      next_date = @frequency.next_occurrence(after: search_head)
      break if next_date.nil? || next_date > effective_end
      
      if next_date >= effective_start
        results << Movement.new(
          amount: @base_amount,
          date: next_date,
          description: @description
        )
      end
      search_head = next_date
    end

    results
  end
end
