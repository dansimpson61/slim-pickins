# frozen_string_literal: true
# Example endpoint for reactive form
# Add to your Sinatra app

# POST /calculations/update
# Receives JSON data, performs calculation, returns HTML fragment
post '/calculations/update' do
  content_type :html
  
  data = JSON.parse(request.body.read)
  
  # Extract parameters
  principal = data['principal'].to_f
  rate = data['rate'].to_f / 100
  years = data['years'].to_i
  
  # Perform calculation
  @result = principal * (1 + rate) ** years
  @interest = @result - principal
  @data = data
  
  # Return HTML fragment (not full page)
  slim :_calculation_results, layout: false
end

# Corresponding partial: views/_calculation_results.slim
# .results-card
#   h3 Results
#   .result-row
#     span.label Final Amount:
#     span.value = "$%.2f" % @result
#   .result-row
#     span.label Interest Earned:
#     span.value = "$%.2f" % @interest
