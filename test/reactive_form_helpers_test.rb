# frozen_string_literal: true

require_relative 'test_helper'

class ReactiveFormHelpersTest < Minitest::Test
  def setup
    @ctx = TestContext.new(path: '/calculator')
  end
  
  def test_reactive_form_basic
    html = @ctx.reactive_form(target: "#results") { "Fields" }
    
    assert_includes html, '<form'
    assert_includes html, 'data-controller="reactive-form"'
    assert_includes html, 'data-reactive-form-target-value="#results"'
    assert_includes html, 'data-reactive-form-debounce-value="300"'
    assert_includes html, "Fields"
    assert_includes html, '</form>'
  end
  
  def test_reactive_form_with_custom_url
    html = @ctx.reactive_form(url: "/custom/endpoint", target: "#results") { "" }
    
    assert_includes html, 'data-reactive-form-url-value="/custom/endpoint"'
  end
  
  def test_reactive_form_with_custom_debounce
    html = @ctx.reactive_form(target: "#results", debounce: 500) { "" }
    
    assert_includes html, 'data-reactive-form-debounce-value="500"'
  end
  
  def test_reactive_form_with_model_hash
    model = { principal: 10000, rate: 7.5 }
    html = @ctx.reactive_form(model: model, target: "#results") { "" }
    
    assert_includes html, 'data-reactive-form-initial-value='
    # Should contain JSON representation of model
    assert_includes html, 'principal'
    assert_includes html, '10000'
  end
  
  def test_reactive_field
    html = @ctx.reactive_field(:amount)
    
    assert_includes html, 'type="number"'
    assert_includes html, 'name="amount"'
    assert_includes html, 'data-action="input->reactive-form#changed"'
    assert_includes html, 'data-reactive-form-target="field"'
  end
  
  def test_reactive_field_with_type
    html = @ctx.reactive_field(:email, type: :email)
    
    assert_includes html, 'type="email"'
  end
  
  def test_reactive_results
    html = @ctx.reactive_results(id: "calc-results") { "Results content" }
    
    assert_includes html, 'id="calc-results"'
    assert_includes html, 'data-reactive-form-target="results"'
    assert_includes html, "Results content"
  end
end
