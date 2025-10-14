# frozen_string_literal: true

module FormHelpers
  # Simple form wrapper
  def simple_form(action, method: :post, **opts, &block)
    content = capture_html(&block)
    controller = opts[:controller] || 'form'
    
    html = "<form action=\"#{action}\" method=\"#{http_method(method)}\" "
    html += "#{stimulus_attrs(controller)}>"
    html += "<input type=\"hidden\" name=\"_method\" value=\"#{method}\">" if [:put, :patch, :delete].include?(method)
    html += content
    html += "</form>"
  end
  
  # Form field
  def field(name, type: :text, label: nil, **opts)
    label_text = label || name.to_s.split('_').map(&:capitalize).join(' ')
    required = opts[:required]
    value = opts[:value]
    
    html = "<div class=\"form-group\">"
    html += "<label for=\"#{name}\">#{label_text}</label>"
    
    if type == :textarea
      html += "<textarea name=\"#{name}\" id=\"#{name}\""
      html += " required" if required
      html += ">#{value}</textarea>"
    elsif type == :select
      html += "<select name=\"#{name}\" id=\"#{name}\""
      html += " required" if required
      html += ">"
      opts[:options]&.each do |opt|
        selected = opt == value ? " selected" : ""
        html += "<option#{selected}>#{opt}</option>"
      end
      html += "</select>"
    else
      html += "<input type=\"#{type}\" name=\"#{name}\" id=\"#{name}\""
      html += " value=\"#{value}\"" if value
      html += " required" if required
      html += ">"
    end
    
    html += "</div>"
  end
  
  # Submit button
  def submit(text = "Submit", **opts)
    css = opts[:class] || "btn btn-primary"
    "<button type=\"submit\" class=\"#{css}\">#{text}</button>"
  end
  
  private
  
  def http_method(method)
    [:get, :post].include?(method) ? method : :post
  end
end
