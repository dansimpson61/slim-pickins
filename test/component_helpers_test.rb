# frozen_string_literal: true

require_relative 'test_helper'

class ComponentHelpersTest < Minitest::Test
  def setup
    @ctx = TestContext.new
  end
  
  def test_card_with_title
    html = @ctx.card("Test Title") { "Content" }
    
    assert_includes html, 'class="card"'
    assert_includes html, '<h2 class="card-title">Test Title</h2>'
    assert_includes html, "Content"
  end
  
  def test_card_without_title
    html = @ctx.card { "Content" }
    
    assert_includes html, 'class="card"'
    refute_includes html, '<h2'
    assert_includes html, "Content"
  end
  
  def test_card_with_controller
    html = @ctx.card("Title", controller: "test")
    
    assert_includes html, 'data-controller="test"'
  end
  
  def test_card_with_custom_class
    html = @ctx.card("Title", class: "special")
    
    assert_includes html, 'class="card special"'
  end
  
  def test_action_button
    html = @ctx.action_button("Click", action: "click->test#action")
    
    assert_includes html, '<button'
    assert_includes html, 'data-action="click->test#action"'
    assert_includes html, 'Click'
    assert_includes html, 'class="btn"'
  end
  
  def test_action_button_with_custom_class
    html = @ctx.action_button("Click", action: "click->test#action", class: "special")
    
    assert_includes html, 'class="special"'
  end
  
  def test_nav_link_active
    ctx = TestContext.new(path: '/test')
    html = ctx.nav_link("Test", "/test")
    
    assert_includes html, 'class="nav-link active"'
    assert_includes html, 'href="/test"'
    assert_includes html, '>Test</a>'
  end
  
  def test_nav_link_inactive
    ctx = TestContext.new(path: '/other')
    html = ctx.nav_link("Test", "/test")
    
    assert_includes html, 'class="nav-link"'
    refute_includes html, "active"
  end
  
  def test_icon
    html = @ctx.icon(:edit)
    
    assert_includes html, '<svg'
    assert_includes html, 'icon-edit'
    assert_includes html, 'href="#icon-edit"'
  end
end
