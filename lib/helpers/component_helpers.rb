# frozen_string_literal: true

module ComponentHelpers
  # Card component - uses semantic <article> element
  def card(title = nil, controller: nil, **opts, &block)
    content = if block_given?
                capture_html(&block) rescue yield
              else
                ""
              end
    
    css_class = "card"
    css_class += " #{opts[:class]}" if opts[:class]
    
    attrs = ""
    attrs += " #{stimulus_attrs(controller)}" if controller
    
    html = "<article class=\"#{css_class}\"#{attrs}>"
    html += "<h2 class=\"card-title\">#{title}</h2>" if title
    html += content
    html += "</article>"
  end
  
  # Action button with Stimulus action
  def action_button(text, action:, **opts)
    css_class = opts[:class] || "btn"
    "<button class=\"#{css_class}\" #{action_attr(action)}>#{text}</button>"
  end
  
  # Navigation link with active state
  def nav_link(text, path, **opts)
    css_class = "nav-link"
    css_class += " active" if request.path == path
    css_class += " #{opts[:class]}" if opts[:class]
    
    "<a href=\"#{path}\" class=\"#{css_class}\">#{text}</a>"
  end
  
  # Icon helper
  def icon(name, **opts)
    css_class = "icon icon-#{name}"
    css_class += " #{opts[:class]}" if opts[:class]
    
    <<~SVG
      <svg class="#{css_class}">
        <use href="#icon-#{name}"></use>
      </svg>
    SVG
  end
  
  private
  
  def capture_html(&block)
    if respond_to?(:capture)
      capture(&block)
    else
      block.call
    end
  end
end
