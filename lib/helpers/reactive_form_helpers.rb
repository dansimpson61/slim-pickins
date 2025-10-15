# frozen_string_literal: true

module ReactiveFormHelpers
  # Create a form that automatically updates on input changes
  def reactive_form(model: nil, target: nil, debounce: 300, url: nil, &block)
    content = if block_given?
                capture_html(&block) rescue yield
              else
                ""
              end
    
    # Determine endpoint - use /calculate as default
    update_url = if url
                   url
                 elsif respond_to?(:request) && request.respond_to?(:path_info)
                   # If we're at /, calculate endpoint is /calculate
                   # If we're at /foo, it's /foo/calculate
                   base = request.path_info == '/' ? '' : request.path_info
                   "#{base}/calculate"
                 else
                   "/calculate"
                 end
    
    model_data = model ? model_attributes(model) : {}
    model_json = model_data.empty? ? '{}' : model_data.to_json.gsub("'", "&#39;")
    
    html = <<~HTML
      <form data-controller="reactive-form"
            data-reactive-form-url-value="#{update_url}"
            data-reactive-form-target-value="#{target}"
            data-reactive-form-debounce-value="#{debounce}"
            data-reactive-form-initial-value='#{model_json}'
            data-action="submit->reactive-form#prevent">
        #{content}
      </form>
    HTML
    
    html
  end
  
  # Enhanced field that participates in reactive updates
  def reactive_field(name, type: :number, **opts)
    label_text = opts[:label] || name.to_s.split('_').map(&:capitalize).join(' ')
    required = opts[:required]
    value = opts[:value]
    
    html = "<div class=\"form-group\">"
    html += "<label for=\"#{name}\">#{label_text}</label>"
    html += "<input type=\"#{type}\" name=\"#{name}\" id=\"#{name}\""
    html += " value=\"#{value}\"" if value
    html += " required" if required
    html += " data-action=\"input->reactive-form#changed\""
    html += " data-reactive-form-target=\"field\""
    html += ">"
    html += "</div>"
  end
  
  # Container for results that will be reactively updated
  def reactive_results(id: "results", &block)
    content = if block_given?
                capture_html(&block) rescue yield
              else
                ""
              end
    "<div id=\"#{id}\" data-reactive-form-target=\"results\">#{content}</div>"
  end
  
  private
  
  def model_attributes(model)
    if model.respond_to?(:attributes)
      model.attributes
    elsif model.respond_to?(:to_h)
      model.to_h
    else
      {}
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
