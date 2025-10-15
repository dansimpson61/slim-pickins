# frozen_string_literal: true

require_relative 'test_helper'

class FormHelpersTest < Minitest::Test
  def setup
    @ctx = TestContext.new
  end
  
  def test_simple_form_post
    html = @ctx.simple_form("/submit") { "Fields" }
    
    assert_includes html, '<form'
    assert_includes html, 'action="/submit"'
    assert_includes html, 'method="post"'
    assert_includes html, 'data-controller="form"'
    assert_includes html, "Fields"
    assert_includes html, '</form>'
  end
  
  def test_simple_form_get
    html = @ctx.simple_form("/search", method: :get) { "" }
    
    assert_includes html, 'method="get"'
    refute_includes html, '_method'
  end
  
  def test_simple_form_with_method_override
    html = @ctx.simple_form("/update", method: :patch) { "" }
    
    assert_includes html, 'method="post"'
    assert_includes html, '<input type="hidden" name="_method" value="patch">'
  end
  
  def test_simple_form_with_custom_controller
    html = @ctx.simple_form("/submit", controller: "custom") { "" }
    
    assert_includes html, 'data-controller="custom"'
  end
  
  def test_field_text_input
    html = @ctx.field(:name)
    
    assert_includes html, '<input type="text"'
    assert_includes html, 'name="name"'
    assert_includes html, 'id="name"'
    assert_includes html, '<label for="name">Name</label>'
    assert_includes html, 'form-group'
  end
  
  def test_field_with_custom_label
    html = @ctx.field(:email, label: "Email Address")
    
    assert_includes html, '>Email Address</label>'
  end
  
  def test_field_textarea
    html = @ctx.field(:description, type: :textarea)
    
    assert_includes html, '<textarea'
    assert_includes html, 'name="description"'
    assert_includes html, '</textarea>'
  end
  
  def test_field_select
    html = @ctx.field(:category, type: :select, options: ["A", "B", "C"])
    
    assert_includes html, '<select'
    assert_includes html, '<option>A</option>'
    assert_includes html, '<option>B</option>'
    assert_includes html, '<option>C</option>'
  end
  
  def test_field_required
    html = @ctx.field(:email, required: true)
    
    assert_includes html, 'required'
  end
  
  def test_field_with_value
    html = @ctx.field(:name, value: "John")
    
    assert_includes html, 'value="John"'
  end
  
  def test_submit_button
    html = @ctx.submit("Save")
    
    assert_includes html, '<button type="submit"'
    assert_includes html, 'class="btn btn-primary"'
    assert_includes html, '>Save</button>'
  end
  
  def test_submit_with_custom_class
    html = @ctx.submit("Delete", class: "btn-danger")
    
    assert_includes html, 'class="btn-danger"'
  end
end
