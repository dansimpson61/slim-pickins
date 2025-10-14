# frozen_string_literal: true

module PatternHelpers
  # Modal dialog
  def modal(id:, trigger: nil, **opts, &block)
    content = capture_html(&block)
    trigger_text = trigger || "Open"
    
    html = "<div #{stimulus_attrs('modal')}>"
    html += "<button #{action_attr('click->modal#open')} class=\"btn\">#{trigger_text}</button>"
    html += "<div data-modal-target=\"backdrop\" class=\"modal-backdrop hidden\">"
    html += "<div data-modal-target=\"panel\" class=\"modal-panel\">"
    html += "<button #{action_attr('click->modal#close')} class=\"modal-close\">×</button>"
    html += content
    html += "</div></div></div>"
  end
  
  # Dropdown menu
  def dropdown(label, **opts, &block)
    content = capture_html(&block)
    
    html = "<div #{stimulus_attrs('dropdown')}>"
    html += "<button #{action_attr('click->dropdown#toggle')} class=\"dropdown-trigger\">#{label}</button>"
    html += "<div data-dropdown-target=\"menu\" class=\"dropdown-menu hidden\">"
    html += content
    html += "</div></div>"
  end
  
  # Menu item for dropdowns
  def menu_item(text, path, **opts)
    method = opts[:method]
    attrs = method ? " data-method=\"#{method}\"" : ""
    "<a href=\"#{path}\"#{attrs} class=\"menu-item\">#{text}</a>"
  end
  
  # Sortable list
  def sortable_list(items, url:, &block)
    html = "<div #{stimulus_attrs('sortable')} data-sortable-url-value=\"#{url}\">"
    html += "<ul class=\"sortable-list\" data-sortable-target=\"container\">"
    
    items.each do |item|
      html += "<li class=\"sortable-item\" data-sortable-id-value=\"#{item.id}\">"
      html += capture_html { block.call(item) }
      html += "</li>"
    end
    
    html += "</ul></div>"
  end
  
  # Searchable list
  def searchable(path, placeholder: "Search...", **opts)
    html = "<div #{stimulus_attrs('search')} data-search-url-value=\"#{path}\">"
    html += "<input type=\"search\" placeholder=\"#{placeholder}\" "
    html += "#{action_attr('input->search#query')} class=\"search-input\">"
    html += "<div data-search-target=\"results\"></div>"
    html += "</div>"
  end
  
  # Tabs
  def tabs(**tab_hash, &block)
    html = "<div #{stimulus_attrs('tabs')}>"
    html += "<div class=\"tab-list\">"
    
    tab_hash.each_with_index do |(key, label), index|
      active = index.zero? ? "active" : ""
      html += "<button #{action_attr('click->tabs#select')} "
      html += "data-tabs-target=\"tab\" data-tab=\"#{key}\" class=\"tab #{active}\">#{label}</button>"
    end
    
    html += "</div>"
    html += "<div class=\"tab-content\" data-tabs-target=\"content\">"
    html += capture_html(&block) if block
    html += "</div></div>"
  end
end
