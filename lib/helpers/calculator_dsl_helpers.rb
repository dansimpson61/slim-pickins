# frozen_string_literal: true

module CalculatorDSLHelpers
  # Domain-specific form builder for calculators
  def calculator_form(title: nil, **opts, &block)
    content = if block_given?
                capture_html(&block) rescue yield
              else
                ""
              end
    
    html = ""
    html += "<h2>#{title}</h2>" if title
    html += reactive_form(**opts) { content }
    html
  end
  
  # Money input field (auto-formats, validates)
  def money_field(name, label: nil, **opts)
    label_text = label || name.to_s.split('_').map(&:capitalize).join(' ')
    value = opts[:value]
    
    <<~HTML
      <div class="form-group">
        <label for="#{name}">#{label_text}</label>
        <div class="input-group">
          <span class="input-prefix">$</span>
          <input type="number" 
                 name="#{name}" 
                 id="#{name}"
                 step="0.01"
                 min="0"
                 value="#{value}"
                 data-action="input->reactive-form#changed"
                 data-reactive-form-target="field">
        </div>
      </div>
    HTML
  end
  
  # Percentage input field
  def percent_field(name, label: nil, **opts)
    label_text = label || name.to_s.split('_').map(&:capitalize).join(' ')
    value = opts[:value]
    
    <<~HTML
      <div class="form-group">
        <label for="#{name}">#{label_text}</label>
        <div class="input-group">
          <input type="number" 
                 name="#{name}" 
                 id="#{name}"
                 step="0.01"
                 min="0"
                 max="100"
                 value="#{value}"
                 data-action="input->reactive-form#changed"
                 data-reactive-form-target="field">
          <span class="input-suffix">%</span>
        </div>
      </div>
    HTML
  end
  
  # Year input with sensible constraints
  def year_field(name, label: nil, min: 1, max: 50, **opts)
    label_text = label || name.to_s.split('_').map(&:capitalize).join(' ')
    value = opts[:value]
    
    <<~HTML
      <div class="form-group">
        <label for="#{name}">#{label_text}</label>
        <input type="number" 
               name="#{name}" 
               id="#{name}"
               min="#{min}"
               max="#{max}"
               value="#{value}"
               data-action="input->reactive-form#changed"
               data-reactive-form-target="field">
      </div>
    HTML
  end
  
  # Results table with automatic formatting
  # Accepts a hash of label => value pairs
  def results_table(data, **opts)
    rows = data.map do |label, value|
      formatted = format_value(value)
      "<tr><td>#{label}</td><td class='numeric'>#{formatted}</td></tr>"
    end.join
    
    <<~HTML
      <table class="results-table">
        <tbody>
          #{rows}
        </tbody>
      </table>
    HTML
  end
  
  # Simple result row helper for when you want to build table manually
  def result_row(label, value)
    formatted = format_value(value)
    "<tr><td>#{label}</td><td class='numeric'>#{formatted}</td></tr>"
  end
  
  private
  
  def format_value(val)
    case val
    when Float
      "$%.2f" % val
    when Integer
      "$%.2f" % val.to_f
    when Numeric
      "$%.2f" % val
    else
      val.to_s
    end
  end
  
  def capture_html(&block)
    if respond_to?(:capture)
      capture(&block)
    else
      block.call
    end
  end
end
