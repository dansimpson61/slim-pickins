# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'minitest/autorun'
require 'minitest/pride'

# Require all the helper modules directly
require_relative '../lib/helpers/component_helpers'
require_relative '../lib/helpers/pattern_helpers'
require_relative '../lib/helpers/form_helpers'
require_relative '../lib/helpers/stimulus_helpers'

# Mock request object for testing
class MockRequest
  attr_accessor :path
  
  def initialize(path = '/test')
    @path = path
  end
end

# Test context that includes all helpers
class TestContext
  include ComponentHelpers
  include PatternHelpers
  include FormHelpers
  include StimulusHelpers
  
  attr_reader :request
  
  def initialize(path: '/test')
    @request = MockRequest.new(path)
  end
end
