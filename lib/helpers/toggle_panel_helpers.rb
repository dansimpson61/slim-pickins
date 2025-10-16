# frozen_string_literal: true

module TogglePanelHelpers
  # Toggle panel system for collapsible edge-aligned panels
  # 
  # @example Basic usage
  #   toggleleft 'Navigation' do
  #     nav_link "Dashboard", "/"
  #     nav_link "Settings", "/settings"
  #   end
  #
  # @example With icon
  #   toggleright 'Tools', icon: '🔧' do
  #     button "New Project"
  #     button "Import"
  #   end
  #
  # @example Iterate over collection
  #   toggletop @filters do |filter|
  #     render partial: 'filter', locals: { filter: filter }
  #   end
  #
  # Philosophy:
  # - Panels in layout.slim are position: fixed (stay on screen)
  # - Panels in other templates are position: absolute (scroll with container)
  # - Adjacent content flows to accommodate panels
  # - Multiple panels can be open simultaneously
  # - CSS-first implementation, minimal JavaScript
  
  def togglepanel(title_or_collection = nil, position: :left, icon: nil, id: nil, **opts, &block)
    # Handle collection vs single render
    if title_or_collection.respond_to?(:each) && !title_or_collection.is_a?(String)
      render_collection_panels(title_or_collection, position: position, icon: icon, id: id, **opts, &block)
    else
      render_single_panel(title_or_collection, position: position, icon: icon, id: id, **opts, &block)
    end
  end
  
  # Convenience aliases for each position
  
  def toggleleft(title_or_collection = nil, **opts, &block)
    togglepanel(title_or_collection, position: :left, **opts, &block)
  end
  
  def toggleright(title_or_collection = nil, **opts, &block)
    togglepanel(title_or_collection, position: :right, **opts, &block)
  end
  
  def toggletop(title_or_collection = nil, **opts, &block)
    togglepanel(title_or_collection, position: :top, **opts, &block)
  end
  
  def togglebottom(title_or_collection = nil, **opts, &block)
    togglepanel(title_or_collection, position: :bottom, **opts, &block)
  end
  
  private
  
  def render_single_panel(title, position:, icon: nil, id: nil, **opts, &block)
    content = capture_block(&block) if block_given?
    
    # Generate unique ID
    panel_id = id || generate_panel_id(title)
    
    # Determine if we're in layout.slim (fixed) or not (scrollable)
    position_class = in_layout_context? ? 'fixed' : 'scrollable'
    
    # Get icon HTML
    icon_html = render_icon(icon, position)
    
    # Get toggle indicator
    indicator = toggle_indicator(position)
    
    # Build panel HTML
    html = <<~HTML
      <aside class="toggle-panel toggle-panel-#{position} #{position_class}" 
             id="#{panel_id}"
             data-controller="toggle-panel"
             data-toggle-panel-position-value="#{position}">
        <header class="panel-header" 
                data-action="click->toggle-panel#toggle"
                role="button"
                tabindex="0"
                aria-expanded="true"
                aria-controls="#{panel_id}-content">
          <div class="panel-header-start">
            #{icon_html}
            <span class="panel-label">#{h(title)}</span>
          </div>
          <button class="toggle-indicator" type="button" aria-hidden="true">
            #{indicator}
          </button>
        </header>
        <div class="panel-content" id="#{panel_id}-content" data-toggle-panel-target="content">
          #{content}
        </div>
      </aside>
    HTML
    
    # Mark as html_safe if the method is available (in Sinatra/Rails)
    html.respond_to?(:html_safe) ? html.html_safe : html
  end
  
  def render_collection_panels(collection, position:, icon: nil, id: nil, **opts, &block)
    # When given a collection, create multiple panels
    result = collection.map.with_index do |item, index|
      # Determine title from item
      title = extract_title_from_item(item)
      
      # Generate unique ID for each panel
      panel_id = id ? "#{id}-#{index}" : generate_panel_id("#{title}-#{index}")
      
      # Capture content for this item
      content = capture_block(item, &block) if block_given?
      
      render_single_panel(title, position: position, icon: icon, id: panel_id, **opts) do
        content
      end
    end.join
    
    # Mark as html_safe if the method is available (in Sinatra/Rails)
    result.respond_to?(:html_safe) ? result.html_safe : result
  end
  
  def render_icon(icon, position)
    return '' unless icon
    
    # If icon is a string, wrap it
    if icon.is_a?(String)
      %(<span class="panel-icon">#{h(icon)}</span>)
    else
      # Assume it's already HTML
      icon
    end
  end
  
  def toggle_indicator(position)
    indicators = {
      left: '◀',
      right: '▶',
      top: '▲',
      bottom: '▼'
    }
    indicators[position] || '●'
  end
  
  def generate_panel_id(title)
    # Generate a URL-safe ID from title
    base = title.to_s.downcase.gsub(/[^a-z0-9]+/, '-').gsub(/^-|-$/, '')
    "panel-#{base}-#{SecureRandom.hex(4)}"
  end
  
  def extract_title_from_item(item)
    # Try common methods to get a title
    if item.respond_to?(:name)
      item.name
    elsif item.respond_to?(:title)
      item.title
    elsif item.respond_to?(:label)
      item.label
    elsif item.respond_to?(:to_s)
      item.to_s
    else
      'Panel'
    end
  end
  
  def in_layout_context?
    # Check if we're rendering from layout.slim
    # This is a heuristic - checks the call stack for layout-related paths
    caller_locations.any? { |loc| loc.path.include?('layout.slim') }
  end
  
  def capture_block(*args, &block)
    if block_given?
      if respond_to?(:capture, true)
        # In Sinatra with content_for-like functionality
        capture(*args, &block)
      else
        # Fallback: just call the block
        block.call(*args)
      end
    end
  end
  
  def h(text)
    # HTML escape helper
    if defined?(Rack::Utils)
      Rack::Utils.escape_html(text.to_s)
    else
      text.to_s.gsub(/[&<>"']/, {
        '&' => '&amp;',
        '<' => '&lt;',
        '>' => '&gt;',
        '"' => '&quot;',
        "'" => '&#39;'
      })
    end
  end
end
