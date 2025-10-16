# Helpers vs Filters: The Division of Labor

> **Understanding the beautiful separation of concerns**

---

## The Core Distinction

### Helpers Create Structure 🏗️
**Helpers answer: "What component do I need?"**

- Generate HTML scaffolding
- Wire up JavaScript behavior
- Manage component boundaries
- Handle state and interaction
- Create semantic structure

### Filters Transform Data ✨
**Filters answer: "How should this data look?"**

- Format numbers, dates, text
- Transform data presentation
- Apply styling/decoration
- Generate inline visualizations
- Handle localization

---

## The Golden Rule

### ✅ Helper = Component Boundary
```slim
/ Helper creates the STRUCTURE
== card "User Profile" do
  / Content goes inside
```

### ✅ Filter = Data Presentation
```slim
/ Filter formats the DATA
.price
  currency:
    = product.price
```

### ❌ Don't Mix Concerns
```slim
/ BAD - helper doing formatting
== formatted_price(product.price)

/ BAD - filter creating structure  
price_card:
  = product.price
```

---

## When to Use Helpers

### 1. Creating Component Boundaries

```slim
/ Cards, panels, sections
== card "Title" do
  p Content

/ Modals, dropdowns, tabs
== modal id: "example" do
  p Modal content

/ Forms, inputs, buttons
== simple_form "/path" do
  == field :name
```

**Why helper?** Creates complete HTML structure with wiring

### 2. Adding Behavior/Interactivity

```slim
/ Reactive forms
== reactive_form model: @calc do
  == money_field :amount

/ Action buttons
== action_button "Save", action: "click->form#save"

/ Live search
== searchable "/search"
```

**Why helper?** Needs Stimulus controllers and data attributes

### 3. Complex Composition

```slim
/ Navigation
== nav_bar do
  == nav_links home: "/", about: "/about"
  == dropdown "Account" do
    == menu_item "Profile", "/profile"

/ Data tables
== data_table @users do
  == column :name
  == column :email
```

**Why helper?** Multiple nested components with relationships

### 4. State Management

```slim
/ Active state
== nav_link "Home", "/"  / Auto-adds "active" class

/ Toggle fields
== toggle_field :notifications, checked: @user.notifications

/ Wizard steps
== wizard_step "Review", completed: @wizard.step > 3
```

**Why helper?** Needs to track and respond to state

---

## When to Use Filters

### 1. Number Formatting

```slim
/ Currency
.price
  currency:
    = product.price
/ Output: $1,234.56

/ Percentage
.rate
  percent:
    = loan.interest_rate
/ Output: 7.5%

/ Delimiter
.count
  number:
    = total_users
/ Output: 1,234,567
```

**Why filter?** Pure data transformation, no structure

### 2. Date/Time Formatting

```slim
/ Short date
.date
  date:
    = order.created_at
/ Output: Oct 16, 2025

/ Relative time
.timestamp
  time_ago:
    = comment.posted_at
/ Output: 2 hours ago

/ Custom format
.datetime
  datetime:
    = event.starts_at
/ Output: October 16, 2025 at 2:30 PM
```

**Why filter?** Transforming temporal data to readable format

### 3. Text Transformation

```slim
/ Truncate
.description
  truncate:
    = product.long_description
/ Output: This is a long description that...

/ Titleize
.heading
  titleize:
    = raw_title
/ Output: This Is The Title

/ Markdown
.content
  markdown:
    = article.body
/ Output: HTML from markdown
```

**Why filter?** Text manipulation, no component needed

### 4. Data Visualization (Inline)

```slim
/ Sparkline
.trend
  sparkline:
    = metrics.daily_values.to_json
/ Output: <svg>tiny chart</svg>

/ Progress bar (inline)
.progress
  progress:
    = task.completion_percentage
/ Output: inline progress indicator

/ Stars rating
.rating
  stars:
    = review.rating
/ Output: ★★★★☆
```

**Why filter?** Small, inline visualizations

### 5. Status Indicators

```slim
/ Badge (via filter)
.status
  badge:
    = user.status
/ Output: <span class="badge badge-active">Active</span>

/ Boolean indicator
.verified
  check:
    = user.verified
/ Output: ✓ or ✗

/ Trend indicator
.change
  trend:
    = stock.price_change
/ Output: ↗ 15% or ↘ 3%
```

**Why filter?** Simple transformation of value to styled output

---

## Side-by-Side Comparison

### Scenario: Product Card

#### ❌ ALL HELPERS (Wrong)
```slim
/ Too much - helpers shouldn't format
== card do
  == heading(product.name)
  == formatted_price(product.price)
  == formatted_rating(product.rating)
  == truncated_description(product.description)
```

**Problem:** Helpers doing formatting work

#### ❌ ALL FILTERS (Wrong)
```slim
/ Impossible - filters can't create structure
product_card:
  name:
    = product.name
  price:
    = product.price
```

**Problem:** Filters can't create component boundaries

#### ✅ BALANCED (Right)
```slim
/ Helper for structure, filters for data
== card class: "product" do
  h3 = product.name
  
  .price
    currency:
      = product.price
  
  .rating
    stars:
      = product.rating
  
  .description
    truncate:
      = product.description
  
  == action_button "Add to Cart", action: "click->cart#add"
```

**Perfect:** Helper creates structure, filters format data

---

## Real-World Examples

### Example 1: Financial Dashboard

```slim
/ STRUCTURE: Helpers create layout
== dashboard "Analytics" do
  
  / STRUCTURE: Card component
  == card "Revenue" do
    
    / DATA: Format with filters
    .value
      currency:
        = @metrics.revenue
    
    .change class=(@metrics.revenue_change > 0 ? "positive" : "negative")
      percent:
        = @metrics.revenue_change
    
    / DATA: Inline visualization
    .trend
      sparkline:
        = @metrics.revenue_daily.to_json
  
  / STRUCTURE: Data table component
  == data_table @transactions do
    == column :id
    
    / DATA: Format in column
    == column :amount do |tx|
      currency:
        = tx.amount
    
    == column :created_at do |tx|
      time_ago:
        = tx.created_at
```

**Notice:**
- `dashboard`, `card`, `data_table`, `column` = HELPERS (structure)
- `currency:`, `percent:`, `sparkline:`, `time_ago:` = FILTERS (data)

### Example 2: User Profile

```slim
/ STRUCTURE: Card with sections
== card "User Profile" do
  
  / STRUCTURE: Avatar component
  == avatar @user, size: :large
  
  h2 = @user.name
  
  / STRUCTURE: Definition list
  dl.user-details
    dt Email
    dd = @user.email
    
    dt Member Since
    dd
      / DATA: Date filter
      date:
        = @user.created_at
    
    dt Last Active
    dd
      / DATA: Relative time filter
      time_ago:
        = @user.last_active_at
    
    dt Status
    dd
      / DATA: Badge filter
      badge:
        = @user.status
  
  / STRUCTURE: Action buttons
  .actions
    == action_button "Edit", action: "click->user#edit"
    == action_button "Delete", action: "click->user#delete", class: "btn-danger"
```

**Notice:**
- `card`, `avatar`, `action_button` = HELPERS (structure)
- `date:`, `time_ago:`, `badge:` = FILTERS (data)

### Example 3: E-commerce Product List

```slim
/ STRUCTURE: Search component
== searchable "/products/search", placeholder: "Find products..."

/ STRUCTURE: Grid layout (utility class + loop)
.product-grid
  - @products.each do |product|
    
    / STRUCTURE: Card component
    == card class: "product-card" do
      
      / STRUCTURE: Image helper
      == image product.image_url, alt: product.name
      
      h3 = product.name
      
      .pricing
        - if product.on_sale?
          .original
            / DATA: Currency filter
            currency:
              = product.original_price
          .sale
            currency:
              = product.sale_price
        - else
          currency:
            = product.price
      
      .meta
        .rating
          / DATA: Stars filter
          stars:
            = product.rating
        
        .stock
          - if product.in_stock?
            .badge.success In Stock
          - else
            .badge.danger Out of Stock
      
      / STRUCTURE: Button with action
      == action_button "Add to Cart", 
                       action: "click->cart#add",
                       data: { product_id: product.id }
```

**Notice:**
- `searchable`, `card`, `image`, `action_button` = HELPERS (structure)
- `currency:`, `stars:` = FILTERS (data)
- Badges here are raw HTML (could be filter too)

---

## Implementation Patterns

### Pattern 1: Helper Returns HTML, Filter Transforms

```ruby
# Helper - creates structure
def card(title = nil, **opts, &block)
  content = capture_html(&block)
  <<~HTML
    <div class="card">
      #{"<h3>#{title}</h3>" if title}
      #{content}
    </div>
  HTML
end

# Filter - transforms data
Slim::Engine.set_options(
  filters: {
    'currency' => ->(text) { "$%.2f" % text.to_f }
  }
)
```

### Pattern 2: Helpers Compose, Filters Decorate

```ruby
# Helpers compose into larger structures
def metric_card(label, value, **opts)
  card(label) do
    %{<div class="metric-value">#{value}</div>}
  end
end

# Filters decorate individual values
Slim::Engine.set_options(
  filters: {
    'percent' => ->(text) { "%.1f%%" % text.to_f }
  }
)
```

### Pattern 3: Helpers Take Blocks, Filters Take Values

```ruby
# Helper - accepts block
def expandable(**opts, &block)
  content = capture_html(&block)
  # ... generates structure
end

# Filter - accepts value
Slim::Engine.set_options(
  filters: {
    'truncate' => ->(text) { text.to_s[0..100] + "..." }
  }
)
```

---

## The Decision Tree

### "Should this be a helper or filter?"

```
START: What do I need to do?

├─ Create HTML structure with multiple elements?
│  └─ HELPER (card, modal, form, table)
│
├─ Add interactive behavior (clicks, updates)?
│  └─ HELPER (action_button, reactive_form, searchable)
│
├─ Wire up Stimulus controllers?
│  └─ HELPER (anything with data-controller)
│
├─ Format a single value for display?
│  └─ FILTER (currency, date, percent)
│
├─ Transform text appearance?
│  └─ FILTER (truncate, titleize, markdown)
│
├─ Create inline visualization of data?
│  └─ FILTER (sparkline, progress, stars)
│
└─ Apply styling/decoration to data?
   └─ FILTER (badge, trend, color_swatch)
```

---

## Anti-Patterns to Avoid

### ❌ Helper Doing Pure Formatting
```ruby
# BAD - helper just formatting
def formatted_price(amount)
  "$%.2f" % amount
end
```
```slim
/ Bad usage
.price = formatted_price(@product.price)
```

**Fix:** Use filter
```slim
.price
  currency:
    = @product.price
```

### ❌ Filter Creating Structure
```ruby
# BAD - filter creating HTML structure
Slim::Engine.set_options(
  filters: {
    'card' => ->(title) { 
      "<div class='card'><h3>#{title}</h3>...</div>" 
    }
  }
)
```

**Fix:** Use helper
```slim
== card "Title" do
  / content
```

### ❌ Mixing Concerns
```ruby
# BAD - helper doing formatting AND structure
def price_card(product)
  formatted = "$%.2f" % product.price
  "<div class='card'><span>#{formatted}</span></div>"
end
```

**Fix:** Separate concerns
```slim
== card do
  .price
    currency:
      = product.price
```

---

## Summary

### Helpers 🏗️
- **Purpose:** Create structure, components, behavior
- **Scope:** Multiple HTML elements, wiring, state
- **Usage:** `== helper_name args do ... end`
- **Returns:** HTML structure with data attributes
- **Examples:** `card`, `modal`, `reactive_form`, `action_button`

### Filters ✨
- **Purpose:** Transform data presentation
- **Scope:** Single value transformation
- **Usage:** `filter_name:\n  = value`
- **Returns:** Formatted string or simple HTML
- **Examples:** `currency:`, `date:`, `sparkline:`, `badge:`

### Together 🍞
```slim
/ The perfect balance
== card "Product" do
  h3 = product.name
  .price
    currency:
      = product.price
  == action_button "Buy", action: "click->cart#add"
```

**Helpers create the stage. Filters dress the actors.** ✨
