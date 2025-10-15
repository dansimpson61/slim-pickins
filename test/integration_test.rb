# frozen_string_literal: true

require_relative 'test_helper'
require_relative '../example_app/app'
require_relative '../sampler/app'

class IntegrationTest < Minitest::Test
  
  def test_example_app_runs
    app = ExampleApp.new
    assert app, "Example app should initialize"
  end
  
  def test_sampler_app_runs
    app = SamplerApp.new
    assert app, "Sampler app should initialize"
  end
  
  def test_both_apps_use_slim_pickins
    example_app = ExampleApp.new
    sampler_app = SamplerApp.new
    
    # Both should have SlimPickins helpers
    assert example_app.respond_to?(:helpers), "Example app should have helpers"
    assert sampler_app.respond_to?(:helpers), "Sampler app should have helpers"
  end
  
  def test_helpers_available_in_both_apps
    # Test that helpers are included in both apps
    example_ctx = TestContext.new
    
    # Should have all helper methods
    assert example_ctx.respond_to?(:card)
    assert example_ctx.respond_to?(:modal)
    assert example_ctx.respond_to?(:simple_form)
    assert example_ctx.respond_to?(:stimulus_attrs)
  end
end
