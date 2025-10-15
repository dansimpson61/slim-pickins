# frozen_string_literal: true

require 'sinatra/base'

# Load helper modules
require_relative 'helpers/component_helpers'
require_relative 'helpers/pattern_helpers'
require_relative 'helpers/form_helpers'
require_relative 'helpers/stimulus_helpers'
require_relative 'helpers/reactive_form_helpers'
require_relative 'helpers/calculator_dsl_helpers'

# Main module
module SlimPickins
  # Load version from separate file only if not already defined
  require_relative 'slim_pickins/version' unless defined?(VERSION)
  
  def self.registered(app)
    app.helpers ComponentHelpers
    app.helpers PatternHelpers
    app.helpers FormHelpers
    app.helpers StimulusHelpers
    app.helpers ReactiveFormHelpers
    app.helpers CalculatorDSLHelpers
    
    # Enable Slim templates
    app.set :slim, {
      pretty: true,
      sort_attrs: false
    }
  end
end

# For standalone use
include ComponentHelpers
include PatternHelpers
include FormHelpers
include StimulusHelpers
include ReactiveFormHelpers
include CalculatorDSLHelpers
