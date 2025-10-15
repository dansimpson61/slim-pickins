# frozen_string_literal: true

require_relative 'test_helper'

class StimulusHelpersTest < Minitest::Test
  def setup
    @ctx = TestContext.new
  end
  
  def test_stimulus_attrs_basic
    html = @ctx.stimulus_attrs("controller")
    
    assert_equal 'data-controller="controller"', html
  end
  
  def test_stimulus_attrs_with_single_value
    html = @ctx.stimulus_attrs("modal", open: "false")
    
    assert_includes html, 'data-controller="modal"'
    assert_includes html, 'data-modal-open-value="false"'
  end
  
  def test_stimulus_attrs_with_multiple_values
    html = @ctx.stimulus_attrs("modal", open: "false", auto_close: "5000")
    
    assert_includes html, 'data-controller="modal"'
    assert_includes html, 'data-modal-open-value="false"'
    assert_includes html, 'data-modal-auto-close-value="5000"'
  end
  
  def test_stimulus_attrs_with_underscored_keys
    html = @ctx.stimulus_attrs("test", my_value: "test")
    
    assert_includes html, 'data-test-my-value-value="test"'
  end
  
  def test_stimulus_attrs_returns_empty_for_nil
    html = @ctx.stimulus_attrs(nil)
    
    assert_equal "", html
  end
  
  def test_action_attr
    html = @ctx.action_attr("click->modal#open")
    
    assert_equal 'data-action="click->modal#open"', html
  end
  
  def test_target_attr
    html = @ctx.target_attr("modal", "backdrop")
    
    assert_equal 'data-modal-target="backdrop"', html
  end
end
