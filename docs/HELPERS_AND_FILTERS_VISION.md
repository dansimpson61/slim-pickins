# The Magic of Helpers + Filters: The Slim-Pickins Vision

> **What happens when Ruby helpers and Slim filters work in perfect harmony?**  
> **Pure joy. Templates that read like poetry. Code that feels like conversation.**

---

## The Two Powers Combined

### What Helpers Enable 🎯

**Helpers hide structure and wiring:**
- Component boundaries (`modal`, `card`, `dropdown`)
- JavaScript integration (Stimulus controllers, data attributes)
- HTML scaffolding (forms, tables, grids)
- Behavioral patterns (reactive updates, live search)
- Accessibility features (ARIA, focus management)

**Helpers let you write WHAT, not HOW:**
```slim
/ You write this:
== modal id: "welcome" do
  p Hello!

/ Not this:
div data-controller="modal" data-modal-open-value="false"
  button data-action="click->modal#open" class="btn" Open
  div data-modal-target="backdrop" class="modal-backdrop hidden"
    div data-modal-target="panel" class="modal-panel"
      button data-action="click->modal#close" ×
      p Hello!
```

---

### What Filters Enable ✨

**Filters handle formatting and transformation:**
- Data presentation (currency, dates, percentages)
- Content transformation (markdown, truncation)
- Data visualization (sparklines, charts)
- Localization (translations, number formats)
- Domain-specific mini-languages

**Filters let you format inline, naturally:**
```slim
/ You write this:
td.numeric
  currency:
    = @total

/ Not this:
td.numeric = number_to_currency(@total)
```

---

## The Beautiful Synthesis

When helpers handle **structure** and filters handle **formatting**, templates become **declarative narratives**:

### Example 1: Financial Calculator

```slim
/ The Dream Template
== calculator "Compound Interest" do
  
  / Helpers create smart inputs
  == money_field :principal, default: 10000
  == percent_field :rate, default: 7.0
  == year_field :years, default: 10, max: 50
  
  / Results format inline with filters
  == results do
    .result
      .label Principal Amount
      .value
        currency:
          = @calc.principal
    
    .result
      .label Final Amount
      .value.highlight
        currency:
          = @calc.final_amount
    
    .result
      .label Interest Earned
      .value
        currency:
          = @calc.interest
    
    .result
      .label Effective Rate
      .value
        percent:
          = @calc.effective_rate
```

**What's happening:**
- ✅ Helper `calculator` creates reactive form wrapper
- ✅ Helpers `money_field`, `percent_field` create appropriate inputs
- ✅ Helper `results` creates update target
- ✅ Filters `currency:`, `percent:` format values inline
- ❌ NO data attributes visible
- ❌ NO formatting logic in template
- ❌ NO JavaScript wiring exposed

---

### Example 2: Data Dashboard

```slim
/ The Dream Template
== dashboard "Sales Analytics" do
  
  / Filters create date ranges
  == date_range_filter :period, default: :last_30_days
  
  / Helpers create metric cards
  .metrics
    == metric "Revenue" do
      .value
        currency:
          = @metrics.revenue
      .change class=trend_class(@metrics.revenue_change)
        percent:
          = @metrics.revenue_change
    
    == metric "Orders" do
      .value= @metrics.orders
      .change class=trend_class(@metrics.order_change)
        percent:
          = @metrics.order_change
  
  / Inline sparklines via filter
  .trends
    .trend-card
      h4 Revenue Trend
      sparkline:
        = @metrics.revenue_daily.to_json
    
    .trend-card
      h4 Order Volume
      sparkline:
        = @metrics.orders_daily.to_json
  
  / Helper creates interactive chart
  == line_chart @metrics.revenue_by_category do
    title "Revenue by Category"
    y_axis format: :currency
```

**What's happening:**
- ✅ Helper `dashboard` sets up reactive container
- ✅ Helper `date_range_filter` creates date picker with auto-submit
- ✅ Helper `metric` creates stat card
- ✅ Filter `currency:` formats money values
- ✅ Filter `percent:` formats percentages  
- ✅ Filter `sparkline:` renders tiny charts
- ✅ Helper `line_chart` creates full chart

---

### Example 3: E-commerce Product Card

```slim
/ The Dream Template
- @products.each do |product|
  == card class: "product" do
    
    == image product.image_url, alt: product.name
    
    h3 = product.name
    
    .price
      - if product.on_sale?
        .original
          currency:
            = product.original_price
        .sale
          currency:
            = product.sale_price
      - else
        currency:
          = product.price
    
    .rating
      stars:
        = product.rating
    
    .stock
      - if product.low_stock?
        .badge.warning Only #{product.stock_count} left!
      - else
        .badge.success In Stock
    
    == button "Add to Cart", action: "click->cart#add", data: { product_id: product.id }
```

**What's happening:**
- ✅ Helper `card` creates container
- ✅ Helper `image` handles responsive images
- ✅ Filter `currency:` formats prices
- ✅ Filter `stars:` renders star rating
- ✅ Helper `button` wires up Stimulus action

---

### Example 4: Admin Data Table

```slim
/ The Dream Template
== data_table @users, searchable: true, sortable: true do
  
  == column :id, width: "80px"
  
  == column :name do |user|
    .user-cell
      == avatar user, size: :small
      .info
        .name = user.full_name
        .email.muted = user.email
  
  == column :created_at, label: "Joined" do |user|
    time_ago:
      = user.created_at
  
  == column :revenue, align: :right do |user|
    currency:
      = user.lifetime_revenue
  
  == column :status do |user|
    badge:
      = user.status
  
  == column :actions, align: :center do |user|
    .actions
      == icon_button :edit, action: "click->user#edit", data: { id: user.id }
      == icon_button :trash, action: "click->user#delete", data: { id: user.id }, class: "danger"
```

**What's happening:**
- ✅ Helper `data_table` creates searchable/sortable table
- ✅ Helper `column` defines columns with custom renderers
- ✅ Helper `avatar` renders user avatar
- ✅ Filter `time_ago:` formats relative time
- ✅ Filter `currency:` formats money
- ✅ Filter `badge:` creates status badge
- ✅ Helper `icon_button` creates action buttons

---

### Example 5: Multi-Step Form Wizard

```slim
/ The Dream Template
== wizard "Account Setup", model: @signup do
  
  == step "Account", icon: :user do
    == email_field :email, required: true, validate: :on_blur
    == password_field :password, required: true, strength: :medium
    == password_field :password_confirmation, required: true
  
  == step "Profile", icon: :id_card do
    == text_field :full_name, required: true
    == phone_field :phone, format: :us
    == date_field :birthday, max: Date.today - 18.years
  
  == step "Preferences", icon: :settings do
    == toggle_field :newsletter, label: "Send me updates"
    == select_field :theme, options: [:light, :dark, :auto], default: :auto
    == slider_field :email_frequency, range: 0..10, label: "Email notifications per week"
  
  == step "Review", icon: :check do
    .review-section
      h4 Account
      .review-item
        .label Email
        .value = @signup.email
      
      h4 Profile  
      .review-item
        .label Name
        .value = @signup.full_name
      .review-item
        .label Phone
        .value
          phone:
            = @signup.phone
```

**What's happening:**
- ✅ Helper `wizard` creates multi-step container with progress
- ✅ Helper `step` creates step with validation
- ✅ Field helpers create inputs with inline validation
- ✅ Filter `phone:` formats phone number for display

---

## The Filter Catalog

### Numeric Filters

```slim
/ Currency formatting
currency:
  = 1234.56
/ Output: $1,234.56

/ Percentage formatting
percent:
  = 0.1234
/ Output: 12.34%

/ Number with delimiter
number:
  = 1234567
/ Output: 1,234,567

/ Ordinal
ordinal:
  = 42
/ Output: 42nd
```

### Date/Time Filters

```slim
/ Short date
date:
  = Time.now
/ Output: Oct 16, 2025

/ Long date
long_date:
  = Time.now
/ Output: October 16, 2025

/ Time ago
time_ago:
  = 2.hours.ago
/ Output: 2 hours ago

/ ISO datetime
iso:
  = Time.now
/ Output: 2025-10-16T14:30:00Z
```

### Text Filters

```slim
/ Truncate
truncate:
  = long_text
/ Output: This is a long text that...

/ Titleize
titleize:
  = "hello world"
/ Output: Hello World

/ Pluralize  
pluralize:
  = "item", count: 5
/ Output: items

/ Markdown
markdown:
  = "**bold** and *italic*"
/ Output: <strong>bold</strong> and <em>italic</em>
```

### Data Visualization Filters

```slim
/ Sparkline (tiny line chart)
sparkline:
  = [1, 5, 2, 8, 3, 9, 4].to_json
/ Output: <svg>...</svg>

/ Mini bar chart
bars:
  = { "Mon": 5, "Tue": 8, "Wed": 3 }.to_json
/ Output: <div class="mini-bars">...</div>

/ Trend indicator
trend:
  = 0.15
/ Output: ↗ 15%

/ Progress bar
progress:
  = 0.65
/ Output: <div class="progress"><div style="width: 65%"></div></div>
```

### Status/Badge Filters

```slim
/ Status badge
badge:
  = "active"
/ Output: <span class="badge badge-success">Active</span>

/ Stars rating
stars:
  = 4.5
/ Output: ★★★★☆

/ Boolean indicator
boolean:
  = true
/ Output: ✓

/ Color swatch
color:
  = "#3b82f6"
/ Output: <span class="color-swatch" style="background: #3b82f6"></span>
```

---

## The Helper Catalog

### Layout Helpers

```slim
== card "Title" do
  / Content

== section "Heading" do
  / Content

== panel class: "highlighted" do
  / Content

== stack spacing: :large do
  / Vertical stack

== cluster spacing: :small, justify: :between do
  / Horizontal cluster
```

### Form Helpers

```slim
== simple_form user_path(@user), method: :patch do
  == text_field :name
  == email_field :email
  == password_field :password
  == textarea_field :bio
  == select_field :role, options: roles
  == checkbox_field :active
  == toggle_field :notifications
  == date_field :birthday
  == file_field :avatar
  == submit "Save"
```

### Interactive Helpers

```slim
== modal id: "confirm", trigger: "Delete" do
  p Are you sure?

== dropdown "Actions" do
  == menu_item "Edit", edit_path
  == menu_item "Delete", delete_path

== tabs home: "Home", profile: "Profile" do
  / Tab content

== accordion do
  == accordion_item "Section 1" do
    p Content 1
```

### Data Display Helpers

```slim
== metric "Revenue", @revenue, trend: :up

== stat_card do
  .value = @count
  .label Users

== progress_bar @percentage

== avatar @user, size: :large

== badge :success, "Active"
```

### Reactive Helpers

```slim
== reactive_form model: @calc, target: "#results" do
  / Form fields

== live_search url: search_path, target: "#results"

== auto_save_form model: @draft do
  / Form fields
```

---

## The Complete Picture: A Real Application

```slim
/ views/analytics/dashboard.slim

doctype html
html
  head
    title Analytics Dashboard
    == stylesheet "slim-pickins"
  
  body
    == nav_bar do
      == logo
      == nav_links do
        == nav_link "Dashboard", dashboard_path
        == nav_link "Reports", reports_path
        == nav_link "Settings", settings_path
      == dropdown "Account" do
        == menu_item "Profile", profile_path
        == menu_item "Logout", logout_path, method: :delete
    
    main.dashboard
      
      / Filters
      == filter_bar do
        == date_range_filter :period, default: :last_30_days
        == select_filter :region, options: @regions
        == search_filter placeholder: "Search metrics..."
      
      / Key metrics
      .metrics-grid
        == metric "Revenue" do
          .value
            currency:
              = @metrics.revenue
          .trend class=trend_class(@metrics.revenue_change)
            trend:
              = @metrics.revenue_change
          sparkline:
            = @metrics.revenue_daily.to_json
        
        == metric "Orders" do
          .value
            number:
              = @metrics.orders
          .trend class=trend_class(@metrics.order_change)
            trend:
              = @metrics.order_change
          sparkline:
            = @metrics.orders_daily.to_json
        
        == metric "Conversion" do
          .value
            percent:
              = @metrics.conversion
          .trend class=trend_class(@metrics.conversion_change)
            trend:
              = @metrics.conversion_change
      
      / Main chart
      == card "Revenue Trend" do
        == line_chart @metrics.revenue_over_time do
          y_axis format: :currency
          x_axis format: :date
      
      / Data tables
      .grid-2
        == card "Top Products" do
          == data_table @top_products do
            == column :name
            == column :revenue, align: :right do |product|
              currency:
                = product.revenue
            == column :change, align: :right do |product|
              trend:
                = product.change
        
        == card "Recent Orders" do
          == data_table @recent_orders do
            == column :id, width: "80px"
            == column :customer
            == column :total, align: :right do |order|
              currency:
                = order.total
            == column :created_at, label: "Date" do |order|
              time_ago:
                = order.created_at
            == column :status do |order|
              badge:
                = order.status
```

**Look at that template! It's:**
- ✅ **Readable** - You can understand it without Ruby knowledge
- ✅ **Expressive** - Says WHAT, not HOW
- ✅ **Concise** - No boilerplate
- ✅ **Maintainable** - Easy to modify
- ✅ **Joyful** - It's actually pleasant to write!

---

## The Implementation Strategy

### Phase 1: Core Helpers (Done ✅)
- Layout: `card`, `section`, `panel`, `stack`, `cluster`
- Forms: `simple_form`, `field` helpers
- Interactive: `modal`, `dropdown`, `tabs`

### Phase 2: Reactive Helpers (Partially Done ⚙️)
- `reactive_form` with auto-update
- Specialized fields: `money_field`, `percent_field`, etc.
- `live_search`, `auto_save`

### Phase 3: Slim Filters (Next 🎯)
```ruby
# config/initializers/slim_filters.rb
Slim::Engine.set_options(
  filters: {
    'currency' => CurrencyFilter,
    'percent' => PercentFilter,
    'date' => DateFilter,
    'time_ago' => TimeAgoFilter,
    'sparkline' => SparklineFilter,
    'trend' => TrendFilter,
    'badge' => BadgeFilter,
    'stars' => StarsFilter,
    'markdown' => MarkdownFilter,
    'truncate' => TruncateFilter
  }
)
```

### Phase 4: Domain Helpers (Future 🚀)
- `calculator` - infers fields from model
- `dashboard` - auto-layouts metrics
- `data_table` - smart tables with sorting/search
- `wizard` - multi-step forms

---

## The Golden Rules

### For Helpers:
1. **Hide all data attributes** - Never expose Stimulus wiring
2. **Accept blocks** - Let content flow naturally
3. **Smart defaults** - Convention over configuration
4. **Composable** - Nest helpers freely

### For Filters:
1. **Format, don't structure** - Transform data, not HTML shape
2. **Readable names** - `currency:`, not `format_currency:`
3. **Consistent output** - Same filter, same result
4. **No side effects** - Pure transformation only

### For Templates:
1. **Express intent** - What do you want to show?
2. **Trust helpers** - Don't micromanage
3. **Format inline** - Use filters for data presentation
4. **Stay semantic** - HTML first, styling second

---

## The North Star

**The perfect Slim-Pickins template reads like a design specification:**

```slim
dashboard "Sales Performance"
  filters
    date_range
    region_select
  
  metrics
    revenue with_trend
    orders with_trend
    conversion with_trend
  
  chart revenue_over_time, format: currency
  
  tables
    top_products
    recent_orders
```

**One day, this will be valid syntax. Until then, we get close:**

```slim
== dashboard "Sales Performance" do
  == filters do
    == date_range_filter :period
    == select_filter :region, options: @regions
  
  == metrics do
    == metric "Revenue", @revenue, trend: @revenue_change
    == metric "Orders", @orders, trend: @order_change
    == metric "Conversion", @conversion, trend: @conversion_change
  
  == line_chart @revenue_over_time, format: :currency
  
  == data_table @top_products
  == data_table @recent_orders
```

---

## Be as good as bread 🍞

**Simple ingredients:**
- Helpers (structure & behavior)
- Filters (formatting & presentation)  
- Slim (expressive syntax)
- Ruby (elegant logic)

**Mixed with care:**
- Hide complexity
- Express intent
- Trust conventions
- Embrace blocks

**The result:**
- Templates that read like poetry
- Code that brings joy
- Interfaces that delight

**This is Slim-Pickins.** ✨
