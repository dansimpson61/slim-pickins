# frozen_string_literal: true

require_relative 'test_helper'

# Define test struct outside the class
TestItem = Struct.new(:id, :name)

class PatternHelpersTest < Minitest::Test
  def setup
    @ctx = TestContext.new
  end
  
  def test_modal_structure
    html = @ctx.modal(id: "test-modal") { "Content" }
    
    assert_includes html, 'data-controller="modal"'
    assert_includes html, 'data-modal-target="backdrop"'
    assert_includes html, 'data-modal-target="panel"'
    assert_includes html, 'modal-close'
    assert_includes html, "Content"
  end
  
  def test_modal_with_custom_trigger
    html = @ctx.modal(id: "test", trigger: "Custom") { "Content" }
    
    assert_includes html, '>Custom</button>'
  end
  
  def test_dropdown_structure
    html = @ctx.dropdown("Menu") { "Items" }
    
    assert_includes html, 'data-controller="dropdown"'
    assert_includes html, 'dropdown-trigger'
    assert_includes html, 'dropdown-menu'
    assert_includes html, '>Menu</button>'
    assert_includes html, "Items"
  end
  
  def test_menu_item
    html = @ctx.menu_item("Link", "/path")
    
    assert_includes html, 'href="/path"'
    assert_includes html, 'class="menu-item"'
    assert_includes html, '>Link</a>'
  end
  
  def test_menu_item_with_method
    html = @ctx.menu_item("Delete", "/path", method: :delete)
    
    assert_includes html, 'data-method="delete"'
  end
  
  def test_searchable
    html = @ctx.searchable("/search")
    
    assert_includes html, 'data-controller="search"'
    assert_includes html, 'data-search-url-value="/search"'
    assert_includes html, 'type="search"'
    assert_includes html, 'placeholder="Search..."'
  end
  
  def test_searchable_with_custom_placeholder
    html = @ctx.searchable("/search", placeholder: "Find items...")
    
    assert_includes html, 'placeholder="Find items..."'
  end
  
  def test_sortable_list
    items = [TestItem.new(1, "First"), TestItem.new(2, "Second")]
    
    html = @ctx.sortable_list(items, url: "/reorder") { |item| item.name }
    
    assert_includes html, 'data-controller="sortable"'
    assert_includes html, 'data-sortable-url-value="/reorder"'
    assert_includes html, 'data-sortable-id-value="1"'
    assert_includes html, 'data-sortable-id-value="2"'
    assert_includes html, "First"
    assert_includes html, "Second"
  end
  
  def test_tabs
    html = @ctx.tabs(home: "Home", about: "About")
    
    assert_includes html, 'data-controller="tabs"'
    assert_includes html, 'data-tabs-target="tab"'
    assert_includes html, 'data-tab="home"'
    assert_includes html, '>Home</button>'
    assert_includes html, '>About</button>'
  end
end
