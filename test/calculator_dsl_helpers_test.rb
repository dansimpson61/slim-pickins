# frozen_string_literal: true

require_relative 'test_helper'

class CalculatorDSLHelpersTest < Minitest::Test
  def setup
    @ctx = TestContext.new
  end
  
  def test_money_field
    html = @ctx.money_field(:principal, value: 10000)
    
    assert_includes html, 'name="principal"'
    assert_includes html, 'type="number"'
    assert_includes html, 'step="0.01"'
    assert_includes html, 'min="0"'
    assert_includes html, 'class="input-prefix">$'
    assert_includes html, 'data-action="input->reactive-form#changed"'
    assert_includes html, 'value="10000"'
  end
  
  def test_money_field_with_custom_label
    html = @ctx.money_field(:amount, label: "Initial Investment")
    
    assert_includes html, '<label for="amount">Initial Investment</label>'
  end
  
  def test_percent_field
    html = @ctx.percent_field(:rate, value: 7.5)
    
    assert_includes html, 'name="rate"'
    assert_includes html, 'type="number"'
    assert_includes html, 'step="0.01"'
    assert_includes html, 'min="0"'
    assert_includes html, 'max="100"'
    assert_includes html, 'class="input-suffix">%'
    assert_includes html, 'value="7.5"'
  end
  
  def test_year_field
    html = @ctx.year_field(:duration, value: 10)
    
    assert_includes html, 'name="duration"'
    assert_includes html, 'type="number"'
    assert_includes html, 'min="1"'
    assert_includes html, 'max="50"'
    assert_includes html, 'value="10"'
  end
  
  def test_year_field_with_custom_range
    html = @ctx.year_field(:years, min: 5, max: 30)
    
    assert_includes html, 'min="5"'
    assert_includes html, 'max="30"'
  end
  
  def test_results_table
    data = {
      "Principal": 10000,
      "Interest": 5427.43,
      "Total": 15427.43
    }
    
    html = @ctx.results_table(data)
    
    assert_includes html, '<table'
    assert_includes html, 'class="results-table"'
    assert_includes html, '<td>Principal</td>'
    assert_includes html, '<td class=\'numeric\'>$10000.00</td>'
    assert_includes html, '<td>Interest</td>'
    assert_includes html, '<td class=\'numeric\'>$5427.43</td>'
  end
end
