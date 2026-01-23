require_relative 'flow'
require_relative 'frequency'

class RecurringFlow
  attr_reader :frequency, :base_amount, :description, :start_date, :end_date, :source_id, :destination_id

  # base_amount should be absolute magnitude.
  def initialize(frequency:, base_amount:, description:, start_date:, source_id:, destination_id:, end_date: nil)
    @frequency = frequency
    @base_amount = base_amount.abs
    @description = description
    @start_date = start_date
    @source_id = source_id
    @destination_id = destination_id
    @end_date = end_date
  end

  # Returns an Array of predicted Flow objects falling strictly within the range
  def projection_between(range_start, range_end)
    effective_start = [range_start, @start_date].max
    effective_end = range_end
    effective_end = [effective_end, @end_date].min if @end_date
    
    return [] if effective_start > effective_end

    results = []
    
    search_head = effective_start - 1
    
    loop do
      next_date = @frequency.next_occurrence(after: search_head)
      break if next_date.nil? || next_date > effective_end
      
      if next_date >= effective_start
        results << Flow.new(
          amount: @base_amount,
          date: next_date,
          description: @description,
          source_id: @source_id,
          destination_id: @destination_id
        )
      end
      search_head = next_date
    end

    results
  end
end
