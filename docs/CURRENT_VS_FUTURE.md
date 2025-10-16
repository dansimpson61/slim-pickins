# Slim-Pickins: Current Capabilities & Future Vision

> **What can you do RIGHT NOW vs what's coming next**

---

## 🎯 What We Have Today (v0.1)

### ✅ Working Helpers

#### Layout & Structure
```slim
/ Cards with content
== card "User Profile" do
  p Content here

/ Sections
== section "Settings" do
  / Settings content

/ Action buttons with Stimulus
== action_button "Save", action: "click->form#save"

/ Navigation with active state
== nav_link "Home", "/"
```

#### Forms
```slim
/ Simple forms
== simple_form "/users", method: :post do
  == field :name, required: true
  == field :email, type: :email
  == submit "Create User"

/ Reactive forms (auto-updating)
== reactive_form model: @calc, target: "#results" do
  == reactive_field :principal, type: :number, value: 10000
  == reactive_field :rate, type: :number, value: 7.0
```

#### Interactive Patterns
```slim
/ Modals
== modal id: "confirm", trigger: "Delete" do
  p Are you sure?
  == action_button "Yes", action: "click->item#delete"

/ Dropdowns  
== dropdown "Actions" do
  == menu_item "Edit", edit_path(item)
  == menu_item "Delete", delete_path(item)

/ Tabs
== tabs home: "Home", profile: "Profile", settings: "Settings" do
  .tab-panels
    / Your tab content

/ Live search
== searchable "/search", placeholder: "Search..."
```

#### Calculator DSL (Domain-Specific)
```slim
== calculator_form title: "Compound Interest", model: @calc, target: "#results" do
  .form-grid
    == money_field :principal, value: 10000
    == percent_field :rate, value: 7.0
    == year_field :years, value: 10

#results
  - data = { \
      "Final Amount": @calc.final_amount, \
      "Interest Earned": @calc.interest \
    }
  == results_table(data)
```

### ✅ Working CSS Framework

```html
<!-- Complete bundle -->
<link rel="stylesheet" href="/assets/stylesheets/slim-pickins.css">

<!-- Or modular -->
<link rel="stylesheet" href="/assets/stylesheets/slim-pickins-tokens.css">
<link rel="stylesheet" href="/assets/stylesheets/slim-pickins-base.css">
<link rel="stylesheet" href="/assets/stylesheets/slim-pickins-utils.css">
```

```slim
/ Utility classes
.stack           / Vertical rhythm
.cluster         / Horizontal flow
.center.prose    / Centered readable content
.card            / Card container
.badge           / Status badges
.btn             / Buttons
```

### ✅ Working Stimulus Integration

All helpers generate proper Stimulus attributes automatically:

```slim
/ You write:
== modal id: "welcome" do
  p Hello

/ Generated HTML includes:
/ data-controller="modal"
/ data-action="click->modal#open"
/ data-modal-target="backdrop"
/ etc.
```

**You never write data attributes yourself!**

---

## ❌ What We DON'T Have Yet

### Slim Filters (Coming Soon)

```slim
/ DOESN'T WORK YET - Coming in v0.2
currency:
  = @amount

percent:
  = @rate

sparkline:
  = @data.to_json
```

**Current workaround:**
```slim
/ Use Ruby helpers instead
= number_to_currency(@amount)
= number_to_percentage(@rate)
```

### Convention-Based Helpers

```slim
/ DOESN'T WORK YET - Future vision
== calculator :compound_interest, model: @calc do
  principal  / Infers type from model
  rate
  years
```

**Current reality:**
```slim
/ Must be explicit
== calculator_form model: @calc do
  == money_field :principal, value: @calc.principal
  == percent_field :rate, value: @calc.rate
  == year_field :years, value: @calc.years
```

### Smart Data Tables

```slim
/ DOESN'T WORK YET - Future
== data_table @users, searchable: true, sortable: true do
  == column :name
  == column :email
  == column :created_at
```

**Current reality:**
```slim
/ Build manually or use searchable + HTML
== searchable "/users/search"

table
  thead
    tr
      th Name
      th Email
      th Created
  tbody
    - @users.each do |user|
      tr
        td = user.name
        td = user.email
        td = user.created_at.strftime("%b %d, %Y")
```

### Wizard/Multi-Step Forms

```slim
/ DOESN'T WORK YET - Future
== wizard "Signup", model: @signup do
  == step "Account" do
    == email_field :email
  == step "Profile" do
    == text_field :name
```

**Current reality:**
```slim
/ Build with conditional rendering
- if @step == 1
  == simple_form signup_path do
    == field :email
    == action_button "Next", action: "click->wizard#next"
- elsif @step == 2
  == simple_form signup_path do
    == field :name
    == submit "Complete"
```

---

## 🚀 Roadmap

### v0.2 - Slim Filters (Next Release)

**Goal:** Inline formatting without Ruby helpers

```ruby
# lib/slim_pickins/filters.rb
Slim::Engine.set_options(
  filters: {
    'currency' => ->(text) { "$%.2f" % text.to_f },
    'percent' => ->(text) { "%.1f%%" % text.to_f },
    'date' => ->(text) { Time.parse(text).strftime("%b %d, %Y") },
    'time_ago' => ->(text) { time_ago_in_words(text) }
  }
)
```

**Usage:**
```slim
.price
  currency:
    = product.price

.growth
  percent:
    = metrics.growth_rate
```

### v0.3 - Enhanced Data Components

**Goal:** Rich data tables, charts, metrics

```slim
== data_table @users, class: "admin-table" do
  == column :avatar do |user|
    == avatar user, size: :small
  == column :name, sortable: true
  == column :email
  == column :role do |user|
    == badge user.role
  == column :actions do |user|
    == action_button "Edit", action: "click->user#edit"

== metric_card "Revenue" do
  .value = number_to_currency(@revenue)
  .change.positive = "+12%"
  == sparkline @revenue_daily
```

### v0.4 - Convention-Based Helpers

**Goal:** Infer intent from context

```slim
/ Auto-detects field types from model attributes
== smart_form @user do
  / Knows 'email' is email field
  / Knows 'password' is password field
  / Knows 'birthday' is date field
  email
  password
  birthday
```

### v1.0 - Full DSL Vision

**Goal:** Pure intent-based templates

```slim
== dashboard "Analytics" do
  filters
    date_range
    region_select
  
  metrics
    revenue with_trend
    orders with_trend
    conversion with_trend
  
  chart :revenue_over_time
  
  tables
    top_products
    recent_orders
```

---

## 📚 Best Practices TODAY

### ✅ DO: Use Helpers for Structure

```slim
/ Good - helpers hide complexity
== card "User Info" do
  p = @user.name

== modal id: "edit", trigger: "Edit User" do
  == simple_form user_path(@user) do
    == field :name, value: @user.name
    == submit "Save"
```

### ❌ DON'T: Write Data Attributes

```slim
/ BAD - exposes implementation details
div data-controller="modal"
  button data-action="click->modal#open" Edit User
  div data-modal-target="backdrop"
    / ...
```

### ✅ DO: Use Ruby for Formatting (Until Filters Arrive)

```slim
/ Good - use Ruby helpers
.price = number_to_currency(@product.price)
.date = @order.created_at.strftime("%b %d, %Y")
.percent = "%.1f%%" % @growth_rate
```

### ❌ DON'T: Format in Controllers

```ruby
# BAD - formatting in controller
def show
  @formatted_price = "$%.2f" % @product.price
end
```

```slim
/ Bad - pre-formatted data
.price = @formatted_price
```

### ✅ DO: Build Hashes for Complex Data

```slim
/ Good - readable multi-line hash
- results = { \
    "Final Amount": "$%.2f" % @calc.final_amount, \
    "Interest Earned": "$%.2f" % @calc.interest, \
    "Years": @calc.years \
  }
== results_table(results)
```

### ✅ DO: Nest Helpers Naturally

```slim
/ Good - composition
== card "User Profile" do
  == avatar @user, size: :large
  
  h3 = @user.name
  
  == dropdown "Actions" do
    == menu_item "Edit", edit_user_path(@user)
    == menu_item "Delete", user_path(@user), method: :delete
```

### ✅ DO: Use Layout Utilities

```slim
/ Good - use framework utilities
.stack
  == card "Item 1" do
    p Content
  == card "Item 2" do
    p Content
  == card "Item 3" do
    p Content

.cluster.cluster-between
  == button "Cancel"
  == button "Save", class: "btn-primary"
```

---

## 🎨 Complete Example: Dashboard (Current Capabilities)

```slim
/ views/dashboard/index.slim
doctype html
html
  head
    title Analytics Dashboard
    link rel="stylesheet" href="/assets/stylesheets/slim-pickins.css"
    script src="/js/app.js"
  
  body
    / Navigation
    nav.topbar
      .container
        h1.logo Slim-Pickins Analytics
        .cluster
          == nav_link "Dashboard", "/"
          == nav_link "Reports", "/reports"
          == nav_link "Settings", "/settings"
          == dropdown "Account" do
            == menu_item "Profile", "/profile"
            == menu_item "Logout", "/logout", method: :delete
    
    / Main content
    main.container
      .stack
        / Filter bar
        == card do
          .cluster
            == searchable "/dashboard/search", placeholder: "Search metrics..."
            
            == simple_form "/dashboard/filter", method: :get do
              == field :date_from, type: :date, label: "From"
              == field :date_to, type: :date, label: "To"
              == submit "Filter"
        
        / Metrics
        .grid-3
          == card "Revenue" do
            .stat-value = number_to_currency(@metrics.revenue)
            .stat-change class=(@metrics.revenue_change > 0 ? "positive" : "negative")
              = "%.1f%%" % @metrics.revenue_change.abs
              span = @metrics.revenue_change > 0 ? "↑" : "↓"
          
          == card "Orders" do
            .stat-value = number_with_delimiter(@metrics.orders)
            .stat-change class=(@metrics.order_change > 0 ? "positive" : "negative")
              = "%.1f%%" % @metrics.order_change.abs
              span = @metrics.order_change > 0 ? "↑" : "↓"
          
          == card "Conversion" do
            .stat-value = "%.2f%%" % @metrics.conversion_rate
            .stat-change class=(@metrics.conversion_change > 0 ? "positive" : "negative")
              = "%.1f%%" % @metrics.conversion_change.abs
              span = @metrics.conversion_change > 0 ? "↑" : "↓"
        
        / Main chart (placeholder for future chart helper)
        == card "Revenue Trend" do
          #chart data-chart-data=@revenue_chart.to_json
          / Chart renders via JavaScript
        
        / Data tables
        .grid-2
          == card "Top Products" do
            table.data-table
              thead
                tr
                  th Product
                  th Revenue
                  th Change
              tbody
                - @top_products.each do |product|
                  tr
                    td = product.name
                    td.numeric = number_to_currency(product.revenue)
                    td.numeric class=(product.change > 0 ? "positive" : "negative")
                      = "%.1f%%" % product.change.abs
          
          == card "Recent Orders" do
            table.data-table
              thead
                tr
                  th ID
                  th Customer
                  th Total
                  th Status
              tbody
                - @recent_orders.each do |order|
                  tr
                    td = order.id
                    td = order.customer_name
                    td.numeric = number_to_currency(order.total)
                    td
                      span class="badge badge-#{order.status}" = order.status.capitalize
```

**Look at that!** 
- ✅ Uses helpers consistently
- ✅ No exposed data attributes
- ✅ Clean, readable structure
- ✅ Proper formatting with Ruby helpers
- ✅ Works TODAY with current codebase

---

## 🔮 Same Dashboard in v1.0 (Future Vision)

```slim
doctype html
html
  head
    title Analytics Dashboard
    == slim_pickins_assets
  
  body
    == nav_bar "Slim-Pickins Analytics" do
      == nav_links dashboard: "/", reports: "/reports", settings: "/settings"
      == account_dropdown
    
    main.container
      == dashboard do
        == filters do
          == search_filter placeholder: "Search metrics..."
          == date_range_filter
        
        == metrics do
          == metric "Revenue" do
            currency:
              = @metrics.revenue
            change:
              = @metrics.revenue_change
          
          == metric "Orders" do
            number:
              = @metrics.orders
            change:
              = @metrics.order_change
          
          == metric "Conversion" do
            percent:
              = @metrics.conversion_rate
            change:
              = @metrics.conversion_change
        
        == line_chart @revenue_chart, title: "Revenue Trend"
        
        .grid-2
          == data_table @top_products, title: "Top Products" do
            == column :name
            == column :revenue, format: :currency, align: :right
            == column :change, format: :percent_change, align: :right
          
          == data_table @recent_orders, title: "Recent Orders" do
            == column :id, width: "80px"
            == column :customer_name, label: "Customer"
            == column :total, format: :currency, align: :right
            == column :status, format: :badge
```

**Much cleaner!**
- ✅ Filters for inline formatting
- ✅ Smart data_table helper
- ✅ Convention-based helpers
- ✅ Even more expressive

---

## 🍞 Be as good as bread

**Start with what we have:**
- Use helpers religiously
- Never write data attributes
- Format with Ruby helpers (for now)
- Trust the framework

**Look forward to what's coming:**
- Slim filters for inline formatting
- Smarter helpers with inference
- Rich data components
- Full DSL vision

**The foundation is solid. The future is bright.** ✨
