# frozen_string_literal: true

require_relative '../helpers/component_helpers'
require_relative '../helpers/pattern_helpers'
require_relative '../helpers/form_helpers'
require_relative '../helpers/stimulus_helpers'

module SlimPickins
  module Helpers
    include ComponentHelpers
    include PatternHelpers
    include FormHelpers
    include StimulusHelpers
  end
end
