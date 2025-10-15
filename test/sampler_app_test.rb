# frozen_string_literal: true

require_relative 'test_helper'
require 'rack/test'
require_relative '../sampler/app'

class SamplerAppTest < Minitest::Test
  include Rack::Test::Methods
  
  def app
    SamplerApp
  end
  
  # ==================
  # Route Tests
  # ==================
  
  def test_home_page_loads
    get '/'
    
    assert last_response.ok?
    assert_includes last_response.body, "Slim-Pickins Sampler"
    assert_includes last_response.body, "Expression over specification"
  end
  
  def test_components_page_loads
    get '/components'
    
    assert last_response.ok?
    assert_includes last_response.body, "Components"
    assert_includes last_response.body, "Cards"
    assert_includes last_response.body, "Buttons"
  end
  
  def test_patterns_page_loads
    get '/patterns'
    
    assert last_response.ok?
    assert_includes last_response.body, "Patterns"
    assert_includes last_response.body, "Modal Dialog"
    assert_includes last_response.body, "Dropdown Menu"
  end
  
  def test_forms_page_loads
    get '/forms'
    
    assert last_response.ok?
    assert_includes last_response.body, "Forms"
    assert_includes last_response.body, "Simple Form"
    assert_includes last_response.body, "Field Types"
  end
  
  def test_stimulus_page_loads
    get '/stimulus'
    
    assert last_response.ok?
    assert_includes last_response.body, "Stimulus Integration"
    assert_includes last_response.body, "data-controller"
  end
  
  # ==================
  # Content Tests
  # ==================
  
  def test_home_shows_philosophy
    get '/'
    
    assert_includes last_response.body, "Expression Over Specification"
    assert_includes last_response.body, "Hide the Ugly Parts"
    assert_includes last_response.body, "Maximize Tool Leverage"
  end
  
  def test_home_shows_quick_start
    get '/'
    
    assert_includes last_response.body, "Quick Start"
    assert_includes last_response.body, "gem 'slim-pickins'"
  end
  
  def test_components_shows_card_examples
    get '/components'
    
    assert_includes last_response.body, "Simple Card"
    assert_includes last_response.body, "== card"
  end
  
  def test_components_shows_button_examples
    get '/components'
    
    assert_includes last_response.body, "action_button"
    assert_includes last_response.body, "Click Me"
  end
  
  def test_components_shows_nav_examples
    get '/components'
    
    assert_includes last_response.body, "nav_link"
    assert_includes last_response.body, "automatically highlighted"
  end
  
  def test_patterns_shows_modal_example
    get '/patterns'
    
    assert_includes last_response.body, "modal"
    assert_includes last_response.body, "Open Modal"
    assert_includes last_response.body, "data-controller=\"modal\""
  end
  
  def test_patterns_shows_dropdown_example
    get '/patterns'
    
    assert_includes last_response.body, "dropdown"
    assert_includes last_response.body, "menu_item"
  end
  
  def test_patterns_shows_searchable_example
    get '/patterns'
    
    assert_includes last_response.body, "searchable"
    assert_includes last_response.body, "Search fruits"
  end
  
  def test_patterns_shows_tabs_example
    get '/patterns'
    
    assert_includes last_response.body, "== tabs"
    assert_includes last_response.body, "Home Panel"
  end
  
  def test_forms_shows_simple_form_example
    get '/forms'
    
    assert_includes last_response.body, "simple_form"
    assert_includes last_response.body, "field :name"
  end
  
  def test_forms_shows_field_types
    get '/forms'
    
    assert_includes last_response.body, "Field Types"
    assert_includes last_response.body, "textarea"
    assert_includes last_response.body, "select"
  end
  
  def test_forms_shows_method_override_example
    get '/forms'
    
    assert_includes last_response.body, "Method Override"
    assert_includes last_response.body, "method: :patch"
  end
  
  def test_stimulus_shows_attribute_examples
    get '/stimulus'
    
    assert_includes last_response.body, "stimulus_attrs"
    assert_includes last_response.body, "action_attr"
    assert_includes last_response.body, "target_attr"
  end
  
  # ==================
  # Demo Endpoint Tests - PROPER TESTS
  # ==================
  
  def test_demo_submit_redirects
    post '/demo/submit'
    
    assert last_response.redirect?
    follow_redirect!
    assert_includes last_request.fullpath, '/forms'
    assert_includes last_request.fullpath, 'success=true'
  end
  
  def test_demo_search_returns_results
    get '/demo/search', q: 'app'
    
    assert last_response.ok?
    assert_includes last_response.body, "Apple"
    refute_includes last_response.body, "Banana"
    refute_includes last_response.body, "Cherry"
  end
  
  def test_demo_search_returns_empty
    get '/demo/search', q: 'xyz'
    
    assert last_response.ok?
    assert_includes last_response.body, "No results found"
  end
  
  def test_demo_search_case_insensitive
    get '/demo/search', q: 'CHERRY'
    
    assert last_response.ok?
    assert_includes last_response.body, "Cherry"
  end
  
  # ==================
  # Navigation Tests
  # ==================
  
  def test_navigation_links_present
    get '/'
    
    assert_includes last_response.body, 'href="/components"'
    assert_includes last_response.body, 'href="/patterns"'
    assert_includes last_response.body, 'href="/forms"'
    assert_includes last_response.body, 'href="/stimulus"'
  end
  
  def test_active_nav_link_highlighted
    get '/components'
    
    # Should have active class on Components link
    assert_includes last_response.body, 'class="nav-link active"'
  end
  
  # ==================
  # Code Example Tests
  # ==================
  
  def test_components_shows_code_examples
    get '/components'
    
    assert_includes last_response.body, '<pre>'
    assert_includes last_response.body, '<code>'
  end
  
  def test_patterns_shows_code_examples
    get '/patterns'
    
    assert_includes last_response.body, '<pre>'
    assert_includes last_response.body, '<code>'
  end
  
  # ==================
  # Asset Tests
  # ==================
  
  def test_css_file_exists
    get '/css/sampler.css'
    
    assert last_response.ok?
    assert_includes last_response.body, '--color-primary'
  end
  
  def test_js_file_exists
    get '/js/app.js'
    
    assert last_response.ok?
    assert_includes last_response.body, 'Stimulus'
  end
  
  # ==================
  # Helper Integration Tests
  # ==================
  
  def test_helpers_render_properly
    get '/components'
    
    # Card helper should render
    assert_includes last_response.body, '<article class="card"'
    
    # Button helper should render
    assert_includes last_response.body, '<button'
  end
  
  def test_stimulus_attributes_present
    get '/patterns'
    
    # Modal should have Stimulus attrs
    assert_includes last_response.body, 'data-controller="modal"'
    assert_includes last_response.body, 'data-modal-target='
  end
end
