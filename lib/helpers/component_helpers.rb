# frozen_string_literal: true

module ComponentHelpers
  # Generate a card component
  def card(title = nil, **opts, &block)
    content = capture_html(&block)
    css_class = "card #{opts[:class]}".strip
    controller = opts[:controller]
    
    html = "<article class=\"#{css_class}\""
    html += " #{stimulus_attrs(controller)}" if controller
    html += ">"
    html += "<h2 class=\"card-title\">#{title}</h2>" if title
    html += content
    html += "</article>"
    html
  end
  
  # Generate action button with Stimulus
  def action_button(label, action:, **opts)
    css = opts[:class] || "btn"
    html = "<button #{action_attr(action)} class=\"#{css}\">"
    html += label
    html += "</button>"
  end
  
  # Navigation link with active state
  def nav_link(text, path, **opts)
    current = request.path == path
    css = ["nav-link"]
    css << "active" if current
    css << opts[:class] if opts[:class]
    
    "<a href=\"#{path}\" class=\"#{css.join(' ')}\">#{text}</a>"
  end
  
  # Icon helper (returns inline SVG or icon markup)
  def icon(name, **opts)
    size = opts[:size] || 24
    css = "icon icon-#{name} #{opts[:class]}".strip
    
    "<svg class=\"#{css}\" width=\"#{size}\" height=\"#{size}\">" \
    "<use href=\"#icon-#{name}\"></use>" \
    "</svg>"
  end
  
  private
  
  def capture_html(&block)
    return "" unless block
    
    if block.arity > 0
      yield
    else
      result = instance_eval(&block)
      result.is_a?(String) ? result : ""
    end
  end
end
