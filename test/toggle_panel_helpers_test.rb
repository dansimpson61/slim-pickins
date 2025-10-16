# frozen_string_literal: true

require_relative 'test_helper'

class TogglePanelHelpersTest < Minitest::Test
  def setup
    @ctx = TestContext.new
  end
  
  # === Basic Rendering Tests ===
  
  def test_toggleleft_with_title
    html = @ctx.toggleleft("Navigation") { "Nav content" }
    
    assert_includes html, '<aside class="toggle-panel toggle-panel-left'
    assert_includes html, '<span class="panel-label">Navigation</span>'
    assert_includes html, 'Nav content'
    assert_includes html, 'data-controller="toggle-panel"'
    assert_includes html, 'data-toggle-panel-position-value="left"'
  end
  
  def test_toggleright_with_title
    html = @ctx.toggleright("Tools") { "Tool content" }
    
    assert_includes html, 'toggle-panel-right'
    assert_includes html, '<span class="panel-label">Tools</span>'
    assert_includes html, 'data-toggle-panel-position-value="right"'
  end
  
  def test_toggletop_with_title
    html = @ctx.toggletop("Filters") { "Filter content" }
    
    assert_includes html, 'toggle-panel-top'
    assert_includes html, '<span class="panel-label">Filters</span>'
    assert_includes html, 'data-toggle-panel-position-value="top"'
  end
  
  def test_togglebottom_with_title
    html = @ctx.togglebottom("Console") { "Console output" }
    
    assert_includes html, 'toggle-panel-bottom'
    assert_includes html, '<span class="panel-label">Console</span>'
    assert_includes html, 'data-toggle-panel-position-value="bottom"'
  end
  
  # === Base Helper Test ===
  
  def test_togglepanel_base_helper
    html = @ctx.togglepanel("Test", position: :left) { "Content" }
    
    assert_includes html, 'toggle-panel-left'
    assert_includes html, '<span class="panel-label">Test</span>'
  end
  
  # === Icon Tests ===
  
  def test_panel_with_icon
    html = @ctx.toggleleft("Nav", icon: "🧭") { "Content" }
    
    assert_includes html, '<span class="panel-icon">🧭</span>'
  end
  
  def test_panel_without_icon
    html = @ctx.toggleleft("Nav") { "Content" }
    
    refute_includes html, '<span class="panel-icon">'
  end
  
  # === Toggle Indicator Tests ===
  
  def test_left_panel_has_left_indicator
    html = @ctx.toggleleft("Nav") { "Content" }
    
    assert_includes html, '◀'
  end
  
  def test_right_panel_has_right_indicator
    html = @ctx.toggleright("Tools") { "Content" }
    
    assert_includes html, '▶'
  end
  
  def test_top_panel_has_up_indicator
    html = @ctx.toggletop("Filters") { "Content" }
    
    assert_includes html, '▲'
  end
  
  def test_bottom_panel_has_down_indicator
    html = @ctx.togglebottom("Console") { "Content" }
    
    assert_includes html, '▼'
  end
  
  # === ID Generation Tests ===
  
  def test_generates_unique_id
    html = @ctx.toggleleft("Navigation") { "Content" }
    
    assert_match(/id="panel-navigation-[a-f0-9]{8}"/, html)
  end
  
  def test_custom_id
    html = @ctx.toggleleft("Nav", id: "custom-nav") { "Content" }
    
    assert_includes html, 'id="custom-nav"'
  end
  
  def test_content_id_matches_aria_controls
    html = @ctx.toggleleft("Nav", id: "test-nav") { "Content" }
    
    assert_includes html, 'aria-controls="test-nav-content"'
    assert_includes html, 'id="test-nav-content"'
  end
  
  # === Accessibility Tests ===
  
  def test_header_has_button_role
    html = @ctx.toggleleft("Nav") { "Content" }
    
    assert_includes html, 'role="button"'
  end
  
  def test_header_has_tabindex
    html = @ctx.toggleleft("Nav") { "Content" }
    
    assert_includes html, 'tabindex="0"'
  end
  
  def test_header_has_aria_expanded
    html = @ctx.toggleleft("Nav") { "Content" }
    
    assert_includes html, 'aria-expanded="true"'
  end
  
  def test_header_has_aria_controls
    html = @ctx.toggleleft("Nav", id: "test") { "Content" }
    
    assert_includes html, 'aria-controls="test-content"'
  end
  
  def test_toggle_indicator_has_aria_hidden
    html = @ctx.toggleleft("Nav") { "Content" }
    
    assert_includes html, 'aria-hidden="true"'
  end
  
  # === Stimulus Integration Tests ===
  
  def test_has_toggle_panel_controller
    html = @ctx.toggleleft("Nav") { "Content" }
    
    assert_includes html, 'data-controller="toggle-panel"'
  end
  
  def test_has_position_value
    html = @ctx.toggleright("Tools") { "Content" }
    
    assert_includes html, 'data-toggle-panel-position-value="right"'
  end
  
  def test_has_click_action
    html = @ctx.toggleleft("Nav") { "Content" }
    
    assert_includes html, 'data-action="click->toggle-panel#toggle"'
  end
  
  def test_has_content_target
    html = @ctx.toggleleft("Nav") { "Content" }
    
    assert_includes html, 'data-toggle-panel-target="content"'
  end
  
  # === Content Rendering Tests ===
  
  def test_renders_content
    html = @ctx.toggleleft("Nav") { "<p>Test content</p>" }
    
    assert_includes html, "<p>Test content</p>"
  end
  
  def test_content_wrapped_in_panel_content
    html = @ctx.toggleleft("Nav") { "Content" }
    
    assert_includes html, '<div class="panel-content"'
    assert_includes html, 'Content'
    assert_includes html, '</div>'
  end
  
  # === HTML Escaping Tests ===
  
  def test_escapes_title_html
    html = @ctx.toggleleft("<script>alert('xss')</script>") { "Content" }
    
    refute_includes html, "<script>"
    assert_includes html, "&lt;script&gt;"
  end
  
  def test_content_not_escaped
    html = @ctx.toggleleft("Nav") { "<strong>Bold</strong>" }
    
    assert_includes html, "<strong>Bold</strong>"
  end
  
  # === Collection Rendering Tests ===
  
  def test_renders_collection
    items = ["Item 1", "Item 2", "Item 3"]
    
    # Note: This test assumes collection handling is implemented
    # The actual implementation might vary
    html = @ctx.toggleleft(items) { |item| "<p>#{item}</p>" }
    
    # Should create multiple panels
    assert_includes html, "Item 1"
    assert_includes html, "Item 2"
    assert_includes html, "Item 3"
  end
  
  # === Structure Tests ===
  
  def test_has_correct_structure
    html = @ctx.toggleleft("Nav") { "Content" }
    
    # Should have aside > header + content
    assert_match(/<aside[^>]*>.*<header[^>]*>.*<\/header>.*<div[^>]*class="panel-content".*<\/div>.*<\/aside>/m, html)
  end
  
  def test_header_has_start_section
    html = @ctx.toggleleft("Nav") { "Content" }
    
    assert_includes html, '<div class="panel-header-start">'
  end
  
  def test_header_has_toggle_indicator_button
    html = @ctx.toggleleft("Nav") { "Content" }
    
    assert_includes html, '<button class="toggle-indicator"'
    assert_includes html, 'type="button"'
  end
  
  # === CSS Class Tests ===
  
  def test_has_base_toggle_panel_class
    html = @ctx.toggleleft("Nav") { "Content" }
    
    assert_includes html, 'class="toggle-panel'
  end
  
  def test_has_position_class
    html = @ctx.toggleright("Tools") { "Content" }
    
    assert_includes html, 'toggle-panel-right'
  end
  
  def test_has_scrollable_class_by_default
    html = @ctx.toggleleft("Nav") { "Content" }
    
    # In non-layout context, should be scrollable
    assert_includes html, 'scrollable'
  end
  
  # === Edge Cases ===
  
  def test_handles_nil_title
    html = @ctx.toggleleft(nil) { "Content" }
    
    # Should still render, with empty label
    assert_includes html, '<aside'
    assert_includes html, 'Content'
  end
  
  def test_handles_empty_content
    html = @ctx.toggleleft("Nav") { "" }
    
    assert_includes html, '<aside'
    assert_includes html, '<span class="panel-label">Nav</span>'
  end
  
  def test_handles_no_block
    html = @ctx.toggleleft("Nav")
    
    assert_includes html, '<aside'
    assert_includes html, '<span class="panel-label">Nav</span>'
  end
  
  # === Integration Tests ===
  
  def test_multiple_panels
    html1 = @ctx.toggleleft("Nav") { "Nav content" }
    html2 = @ctx.toggleright("Tools") { "Tool content" }
    
    refute_equal html1, html2
    assert_includes html1, 'toggle-panel-left'
    assert_includes html2, 'toggle-panel-right'
  end
  
  def test_panel_ids_are_unique
    html1 = @ctx.toggleleft("Nav") { "Content 1" }
    html2 = @ctx.toggleleft("Nav") { "Content 2" }
    
    # Extract IDs from both panels
    id1 = html1[/id="([^"]+)"/, 1]
    id2 = html2[/id="([^"]+)"/, 1]
    
    refute_equal id1, id2
  end
end
