# frozen_string_literal: true

require_relative 'test_helper'
require 'fileutils'

class DocumentationTest < Minitest::Test
  
  def test_getting_started_exists
    assert File.exist?('docs/getting_started.md'), "Getting started guide should exist"
  end
  
  def test_getting_started_has_installation
    content = File.read('docs/getting_started.md')
    
    assert_includes content, "Installation"
    assert_includes content, "gem 'slim-pickins'"
  end
  
  def test_getting_started_has_setup
    content = File.read('docs/getting_started.md')
    
    assert_includes content, "Setup with Sinatra"
    assert_includes content, "register SlimPickins"
  end
  
  def test_getting_started_has_key_concepts
    content = File.read('docs/getting_started.md')
    
    assert_includes content, "Use `==` for Helpers"
    assert_includes content, "Helpers Take Blocks"
  end
  
  def test_getting_started_has_troubleshooting
    content = File.read('docs/getting_started.md')
    
    assert_includes content, "Troubleshooting"
    assert_includes content, "Raw HTML is showing"
  end
  
  def test_helpers_reference_exists
    assert File.exist?('docs/helpers_reference.md'), "Helpers reference should exist"
  end
  
  def test_helpers_reference_documents_all_helpers
    content = File.read('docs/helpers_reference.md')
    
    # Component helpers
    assert_includes content, "### `card`"
    assert_includes content, "### `action_button`"
    assert_includes content, "### `nav_link`"
    assert_includes content, "### `icon`"
    
    # Pattern helpers
    assert_includes content, "### `modal`"
    assert_includes content, "### `dropdown`"
    assert_includes content, "### `searchable`"
    assert_includes content, "### `tabs`"
    
    # Form helpers
    assert_includes content, "### `simple_form`"
    assert_includes content, "### `field`"
    assert_includes content, "### `submit`"
    
    # Stimulus helpers
    assert_includes content, "### `stimulus_attrs`"
    assert_includes content, "### `action_attr`"
    assert_includes content, "### `target_attr`"
  end
  
  def test_helpers_reference_has_signatures
    content = File.read('docs/helpers_reference.md')
    
    assert_includes content, "**Signature:**"
    assert_includes content, "```ruby"
  end
  
  def test_helpers_reference_has_examples
    content = File.read('docs/helpers_reference.md')
    
    assert_includes content, "**Examples:**"
    assert_includes content, "```slim"
  end
  
  def test_examples_doc_exists
    assert File.exist?('docs/examples.md'), "Examples doc should exist"
  end
  
  def test_examples_has_crud
    content = File.read('docs/examples.md')
    
    assert_includes content, "Complete CRUD Application"
    assert_includes content, "get '/items'"
    assert_includes content, "post '/items'"
  end
  
  def test_examples_has_authentication
    content = File.read('docs/examples.md')
    
    assert_includes content, "User Authentication"
    assert_includes content, "login"
  end
  
  def test_examples_has_dashboard
    content = File.read('docs/examples.md')
    
    assert_includes content, "Dashboard"
  end
  
  def test_examples_has_tips
    content = File.read('docs/examples.md')
    
    assert_includes content, "Tips for Real Apps"
  end
end
