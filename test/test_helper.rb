# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'minitest/autorun'
require 'minitest/pride'
require 'json'

# Require all the helper modules directly
require_relative '../lib/helpers/component_helpers'
require_relative '../lib/helpers/pattern_helpers'
require_relative '../lib/helpers/form_helpers'
require_relative '../lib/helpers/stimulus_helpers'
require_relative '../lib/helpers/reactive_form_helpers'
require_relative '../lib/helpers/calculator_dsl_helpers'

# Mock request object for testing
class MockRequest
  attr_accessor :path, :path_info
  
  def initialize(path = '/test')
    @path = path
    @path_info = path
  end
end

# Test context that includes all helpers
class TestContext
  include ComponentHelpers
  include PatternHelpers
  include FormHelpers
  include StimulusHelpers
  include ReactiveFormHelpers
  include CalculatorDSLHelpers
  
  attr_reader :request
  
  def initialize(path: '/test')
    @request = MockRequest.new(path)
  end
end
