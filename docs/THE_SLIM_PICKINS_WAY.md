# The Slim-Pickins Way: A Summary

> **Helpers + Filters + Slim = Joy**

---

## The Vision in One Sentence

**Slim-Pickins templates should read like a conversation about what you want the UI to do, not a specification of how to build it.**

---

## The Core Principles

### 1. Expression Over Specification
```slim
/ You write WHAT you want
== modal id: "welcome" do
  p Hello!

/ Not HOW to build it
div data-controller="modal"
  button data-action="click->modal#open" Open
  / ... 15 more lines
```

### 2. Helpers for Structure, Filters for Data

**Helpers** create components and behavior:
- `== card`, `== modal`, `== tabs`
- `== reactive_form`, `== searchable`
- `== action_button`, `== nav_link`

**Filters** transform data presentation:
- `currency:` → $1,234.56
- `percent:` → 12.5%
- `sparkline:` → tiny chart
- `time_ago:` → 2 hours ago

### 3. Hide All Complexity

**Never expose:**
- ❌ Data attributes (`data-controller`, `data-action`)
- ❌ Stimulus wiring
- ❌ JavaScript implementation details
- ❌ HTML scaffolding

**Always provide:**
- ✅ Clean, expressive helper syntax
- ✅ Semantic HTML output
- ✅ Automatic interactivity
- ✅ Accessible markup

### 4. Compose Naturally

```slim
/ Helpers nest like Russian dolls
== card "User Profile" do
  == avatar @user, size: :large
  
  h3 = @user.name
  
  == dropdown "Actions" do
    == menu_item "Edit", edit_path
    == menu_item "Delete", delete_path
  
  == action_button "Message", action: "click->chat#open"
```

### 5. Progressive Enhancement

```slim
/ Start with working HTML
<form action="/login" method="post">
  <input type="email" name="email">
  <button>Login</button>
</form>

/ Enhance with helpers
== simple_form "/login" do
  == field :email, type: :email
  == submit "Login"

/ Add interactivity where it brings joy
== reactive_form model: @calc, target: "#results" do
  == money_field :amount
```

---

## What We Have Today (v0.1)

### ✅ Working Now

**Layout Helpers:**
- `card`, `section`, `panel`
- `stack`, `cluster` (via CSS)

**Form Helpers:**
- `simple_form`
- `field`, `submit`
- `reactive_form`
- `money_field`, `percent_field`, `year_field`

**Interactive Helpers:**
- `modal`, `dropdown`, `tabs`
- `searchable`
- `action_button`, `nav_link`

**Data Helpers:**
- `results_table`
- `avatar`, `icon`

**CSS Framework:**
- Tufte-inspired tokens
- Semantic base styles
- Utility classes
- Print-friendly

### ❌ Coming Soon

**Slim Filters (v0.2):**
```slim
currency:
  = @amount
percent:
  = @rate
sparkline:
  = @data.to_json
```

**Smart Data Tables (v0.3):**
```slim
== data_table @users do
  == column :name, sortable: true
  == column :email
```

**Convention-Based Helpers (v0.4):**
```slim
== calculator model: @calc do
  principal  / Infers type!
  rate
  years
```

---

## The Division of Labor

### Helpers Create Structure 🏗️

**When to use helpers:**
- Creating component boundaries
- Adding behavior/interactivity
- Complex composition
- State management

**Examples:**
```slim
== card "Title" do
== modal id: "x" do
== reactive_form model: @calc do
== action_button "Save", action: "click->form#save"
```

### Filters Transform Data ✨

**When to use filters:**
- Number formatting
- Date/time formatting
- Text transformation
- Inline visualizations
- Status indicators

**Examples:**
```slim
currency:
  = @price
time_ago:
  = @created_at
truncate:
  = @long_text
badge:
  = @status
```

---

## The Golden Rules

### For Helpers:
1. ✅ Hide all data attributes
2. ✅ Accept blocks for content
3. ✅ Smart defaults, minimal config
4. ✅ Compose freely

### For Filters:
1. ✅ Format, don't structure
2. ✅ Readable names
3. ✅ Consistent output
4. ✅ No side effects

### For Templates:
1. ✅ Express intent
2. ✅ Trust helpers
3. ✅ Format inline
4. ✅ Stay semantic

---

## Anti-Patterns to Avoid

### ❌ Exposed Implementation
```slim
/ BAD - data attributes visible
div data-controller="modal"
  button data-action="click->modal#open" Open
```
**Fix:** Use helpers

### ❌ Helper Doing Formatting
```ruby
# BAD - helper just formatting
def formatted_price(amount)
  "$%.2f" % amount
end
```
**Fix:** Use filter (when available) or format in template

### ❌ Raw HTML for Components
```slim
/ BAD - manual structure
<div class="card">
  <h3>Title</h3>
  <div class="card-body">
    Content
  </div>
</div>
```
**Fix:** Use `== card` helper

### ❌ Formatting in Controllers
```ruby
# BAD
def show
  @formatted_price = "$%.2f" % @product.price
end
```
**Fix:** Format in template

---

## Beautiful Template Patterns

### Pattern 1: Dashboard
```slim
== dashboard "Analytics" do
  == filters do
    == date_range_filter
    == search_filter
  
  .metrics-grid
    == metric "Revenue" do
      .value = number_to_currency(@revenue)
      .change = "+12%"
  
  == data_table @orders
```

### Pattern 2: E-commerce
```slim
.product-grid
  - @products.each do |product|
    == card class: "product" do
      == image product.image_url
      h3 = product.name
      .price = number_to_currency(product.price)
      == action_button "Add to Cart", action: "click->cart#add"
```

### Pattern 3: Form with Validation
```slim
== simple_form user_path(@user), method: :patch do
  == field :name, value: @user.name, required: true
  == field :email, type: :email, value: @user.email, required: true
  == field :bio, type: :textarea, value: @user.bio
  == submit "Save Changes"
```

### Pattern 4: Interactive Calculator
```slim
== calculator_form model: @calc, target: "#results" do
  .form-grid
    == money_field :principal, value: 10000
    == percent_field :rate, value: 7.0
    == year_field :years, value: 10

#results
  - data = { \
      "Final Amount": number_to_currency(@calc.final_amount), \
      "Interest": number_to_currency(@calc.interest) \
    }
  == results_table(data)
```

### Pattern 5: Settings Page
```slim
== tabs profile: "Profile", security: "Security" do
  .tab-panels
    .panel data-tab="profile"
      == simple_form profile_path do
        == field :name
        == field :email
        == submit "Save"
    
    .panel data-tab="security"
      == simple_form password_path do
        == field :current_password, type: :password
        == field :new_password, type: :password
        == submit "Update"
```

---

## The Roadmap

### Phase 1: Core Helpers ✅ (Done)
Clean, composable helpers for structure and behavior

### Phase 2: Reactive Forms ⚙️ (Partial)
Auto-updating forms with domain-specific fields

### Phase 3: Slim Filters 🎯 (Next)
Inline data transformation and formatting

### Phase 4: Smart Components 🚀 (Future)
- Data tables with sorting/filtering
- Charts and visualizations
- Wizard/multi-step forms

### Phase 5: Convention-Based 🌟 (Vision)
Infer intent from context, minimal configuration

---

## Quick Reference

### Must Read Docs:
1. **HELPERS_AND_FILTERS_VISION.md** - The big picture
2. **HELPERS_VS_FILTERS.md** - When to use what
3. **CURRENT_VS_FUTURE.md** - What works now vs coming soon
4. **BEAUTIFUL_TEMPLATES.md** - Real examples

### Key Files:
- `lib/helpers/component_helpers.rb` - Card, button, nav
- `lib/helpers/pattern_helpers.rb` - Modal, dropdown, tabs
- `lib/helpers/form_helpers.rb` - Forms and fields
- `lib/helpers/reactive_form_helpers.rb` - Auto-updating forms
- `lib/helpers/calculator_dsl_helpers.rb` - Domain-specific fields
- `lib/helpers/stimulus_helpers.rb` - Low-level wiring (hidden!)

### CSS Framework:
- `assets/stylesheets/slim-pickins-tokens.css` - Design tokens
- `assets/stylesheets/slim-pickins-base.css` - Semantic styles
- `assets/stylesheets/slim-pickins-utils.css` - Utility classes
- `assets/stylesheets/slim-pickins.css` - Complete bundle

---

## Start Here

### 1. Install
```ruby
gem 'slim-pickins', '~> 0.1'
```

### 2. Register in Sinatra
```ruby
require 'slim-pickins'
class App < Sinatra::Base
  register SlimPickins
end
```

### 3. Include CSS
```html
<link rel="stylesheet" href="/assets/stylesheets/slim-pickins.css">
```

### 4. Write Beautiful Templates
```slim
== card "Welcome" do
  p Start building with joy!
```

---

## The North Star

**One day, this will be valid:**
```slim
dashboard
  filters
  metrics
  chart
  tables
```

**Today, we get close:**
```slim
== dashboard "Analytics" do
  == filters do
    == date_range_filter
  == metrics do
    == metric "Revenue", @revenue
  == line_chart @data
  == data_table @records
```

**And it's already joyful.** ✨

---

## Be as good as bread 🍞

**Simple ingredients:**
- Helpers (structure)
- Filters (formatting)
- Slim (syntax)
- Ruby (logic)
- CSS (design)

**Mixed with care:**
- Hide complexity
- Express intent
- Trust conventions
- Embrace composition

**The result:**
- Templates that read like poetry
- Code that brings joy
- Interfaces that delight
- Development that flows

**This is Slim-Pickins.** 

Welcome home. 🏡
