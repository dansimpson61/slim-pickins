class Movement
  attr_reader :id, :amount, :date, :description, :type, :tax_info

  def initialize(id: nil, amount:, date:, description:, type: nil, tax_info: {})
    @id = id
    @amount = amount
    @date = date
    @description = description
    # If type is not provided, infer from amount? 
    # Or keep it simple: generic bucket unless specified.
    @type = type || (@amount >= 0 ? :income : :expense)
    @tax_info = tax_info
  end

  def to_h
    {
      'id' => @id,
      'amount' => @amount,
      'date' => @date,
      'description' => @description,
      'type' => @type,
      'tax_info' => @tax_info
    }
  end
end
