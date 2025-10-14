# frozen_string_literal: true

module StimulusHelpers
  # Generate Stimulus controller attributes
  def stimulus_attrs(controller, **values)
    return "" unless controller
    
    attrs = ["data-controller=\"#{controller}\""]
    
    values.each do |key, value|
      param_name = key.to_s.gsub('_', '-')
      attrs << "data-#{controller}-#{param_name}-value=\"#{value}\""
    end
    
    attrs.join(" ")
  end
  
  # Generate Stimulus action attribute
  def action_attr(action)
    "data-action=\"#{action}\""
  end
  
  # Generate Stimulus target attribute
  def target_attr(controller, target)
    "data-#{controller}-target=\"#{target}\""
  end
end
