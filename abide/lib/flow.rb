class Flow
  attr_reader :id, :amount, :date, :description, :source_id, :destination_id, :tax_info

  # Amount is always absolute (unsigned magnitude)
  def initialize(id: nil, amount:, date:, description:, source_id:, destination_id:, tax_info: {})
    @id = id
    @amount = amount.abs
    @date = date
    @description = description
    @source_id = source_id
    @destination_id = destination_id
    @tax_info = tax_info
  end

  def to_h
    {
      'id' => @id,
      'amount' => @amount,
      'date' => @date,
      'description' => @description,
      'source_id' => @source_id,
      'destination_id' => @destination_id,
      'tax_info' => @tax_info
    }
  end

  # Returns the signed effect of this flow on a specific account
  def value_for(account_id)
    return -@amount if @source_id == account_id
    return @amount if @destination_id == account_id
    0.0
  end

  # Helper to identify if this is an inflow, outflow, or transfer relative to a perspective
  # For the main portfolio, we often care if it increases or decreases value.
  def type_for(account_id)
    return :outflow if @source_id == account_id
    return :inflow if @destination_id == account_id
    :neutral
  end
end
