# The Slim-Pickins UI/UX DSL Vision

## Summary of Our Discussion

### Core Intent
We discussed evolving slim-pickins from a helper library into a **clean UI/UX DSL** where templates express **intent** rather than implementation. The goal: write what you want to happen, not how to make it happen.

### Key Principles Discussed

1. **Expression Over Specification**
   - Bad: `div data-controller="modal" data-modal-open-value="false"`
   - Good: `== modal id: "my-modal" do`

2. **Hide the Ugly Parts**
   - HTML attributes are implementation details
   - JavaScript wiring should be invisible
   - Data attributes generated automatically

3. **Three Levels of Abstraction**
   - **Level 1 (Low-level)**: Maximum control, explicit wiring
   - **Level 2 (Domain-aware)**: Balance of control and convenience
   - **Level 3 (Intent-first)**: Pure expression, convention over configuration

4. **Slim Filters for Clean Syntax**
   - Custom filters for common patterns
   - Formatting without cluttering templates
   - Domain-specific languages embedded in Slim

5. **Two-Way Data Binding Feel**
   - Server-first architecture
   - Automatic updates via HTML-over-the-wire
   - Debounced, reactive forms
   - No explicit submit buttons

### What We Built

We created **Level 2** helpers that balance expressiveness with explicitness:

```slim
== reactive_form model: @calc, target: "#results" do
  == money_field :principal, value: @calc.principal
  == percent_field :rate, value: @calc.rate
  == year_field :years, value: @calc.years
```

This is good, but we envisioned going further...

---

## Future Vision: Level 3 DSL Examples

### Example 1: Financial Calculator (Convention-Based)

**Current (Level 2):**
```slim
== reactive_form model: @calc, target: "#results" do
  .form-grid
    == money_field :principal, value: @calc.principal
    == percent_field :rate, value: @calc.rate
    == year_field :years, value: @calc.years

#results
  == results_table data
```

**Future (Level 3):**
```slim
== calculator :compound_interest, model: @calc do
  principal
  rate
  years
```

The `calculator` helper would:
- Infer field types from model attributes
- Generate appropriate input fields automatically
- Set up reactive updates by convention
- Render results in the right place
- Handle all Stimulus wiring invisibly

### Example 2: Data Dashboard with Filters

**Future Vision:**
```slim
== dashboard "Sales Performance" do
  
  == filters do
    date_range :period
    category_select :product_line
    region_select :territory
  
  == metrics do
    metric "Revenue", @data.revenue, trend: :up, change: "+12%"
    metric "Orders", @data.orders, trend: :down, change: "-3%"
    metric "AOV", @data.aov, format: :currency
  
  == chart :line, @data.revenue_by_month do
    title "Monthly Revenue Trend"
    y_axis format: :currency
```

Everything updates reactively when filters change. No explicit event handlers.

### Example 3: Forms with Inline Validation

**Future Vision:**
```slim
== smart_form :user, model: @user do
  
  fieldset "Basic Info"
    email :address, required: true
    phone :mobile, format: :us
    password :password, strength: :medium
  
  fieldset "Preferences"
    toggle :newsletter, label: "Send me updates"
    choice :theme, options: [:light, :dark, :auto]
    slider :notifications, range: 0..10, label: "Frequency"
  
  actions
    submit "Create Account"
    link "Cancel", href: "/login"
```

The `smart_form` helper would:
- Validate inline as user types
- Show errors contextually
- Handle all AJAX submission
- Render success/error states
- Track dirty state
- Prevent double-submit

### Example 4: Tables with Inline Editing

**Future Vision:**
```slim
== data_table @items, editable: true do
  
  column :name, sortable: true
  column :price, format: :currency, editable: :inline
  column :stock, type: :number, editable: :inline
  column :status, type: :badge
  
  actions do
    edit_row
    delete_row confirm: "Are you sure?"
```

Click any editable cell to edit inline. Changes save automatically. No page reload.

### Example 5: Wizards/Multi-Step Forms

**Future Vision:**
```slim
== wizard :onboarding, model: @onboarding do
  
  step "Account", icon: :user do
    email :email
    password :password
    password_confirmation :password_confirmation
  
  step "Profile", icon: :id_card do
    text :full_name
    date :birthday
    select :country, options: Country.all
  
  step "Preferences", icon: :settings do
    toggle :newsletter
    multiselect :interests, options: Interest.all
  
  step "Review", icon: :check do
    summary  # Shows review of all previous steps
```

Progress indicator, validation per step, can go back/forward, saves drafts.

### Example 6: Using Slim Filters for Formatting

**Future Vision with Custom Filters:**
```slim
== card "Investment Summary" do
  
  table
    tr
      td Principal
      td.numeric
        currency:
          = @calc.principal
    
    tr
      td Final Amount
      td.numeric
        currency:
          = @calc.final_amount
    
    tr
      td Growth
      td.numeric
        percent:
          = @calc.growth_rate
  
  / Sparkline embedded via filter
  .trend
    sparkline:
      = @calc.historical_values
```

Slim filters handle formatting:
```ruby
Slim::Engine.set_options(
  filters: {
    'currency' => ->(text) { "$%.2f" % text.to_f },
    'percent' => ->(text) { "%.1f%%" % text.to_f },
    'sparkline' => ->(data) { render_sparkline(data) }
  }
)
```

### Example 7: Search with Autocomplete

**Future Vision:**
```slim
== search_field :query,
               autocomplete: "/api/search",
               min_chars: 3,
               debounce: 300,
               results: "#search-results"

#search-results
  / Results appear here automatically
```

Types, waits 300ms, fetches suggestions, displays them. All automatic.

### Example 8: Drag-and-Drop Sortable Lists

**Future Vision:**
```slim
== sortable_list @tasks, url: "/tasks/reorder" do |task|
  
  card class: "task-card" do
    h4 = task.title
    p.muted = task.description
    
    actions do
      edit_link task
      delete_link task, confirm: true
```

Drag to reorder. Order saves via AJAX automatically. Optimistic UI updates.

### Example 9: Real-Time Notifications

**Future Vision:**
```slim
== notifications channel: "user_#{current_user.id}" do
  
  / Notifications appear here in real-time
  / Styled automatically based on type
  / Auto-dismiss after 5 seconds
```

Backend pushes notifications, they appear automatically. No polling.

### Example 10: Comparison View

**Future Vision:**
```slim
== comparison "Investment Scenarios" do
  
  scenario "Conservative" do
    principal: 10000
    rate: 5.0
    years: 20
  
  scenario "Moderate" do
    principal: 10000
    rate: 7.5
    years: 20
  
  scenario "Aggressive" do
    principal: 10000
    rate: 10.0
    years: 20
  
  / Automatically shows side-by-side comparison
  / with charts, tables, and key metrics
```

---

## Implementation Strategy

### Phase 1: Enhanced Helpers (Already Done ✅)
```slim
== money_field :principal
== percent_field :rate
== reactive_form model: @calc
```

### Phase 2: Convention-Based Helpers (Next)
```slim
== calculator :compound_interest do
  principal  # Infers type from model
  rate       # Infers type from model
  years      # Infers type from model
```

### Phase 3: Slim Filters (Next)
```ruby
Slim::Engine.set_options(filters: {
  'currency' => CurrencyFilter,
  'sparkline' => SparklineFilter,
  'chart' => ChartFilter
})
```

```slim
currency:
  = @amount

sparkline:
  = @data_points
```

### Phase 4: Smart Components (Future)
```slim
== smart_form @user do
  / Infers all fields from model
  / Generates appropriate inputs
  / Handles validation automatically
```

### Phase 5: Domain-Specific DSLs (Future)
```slim
== dashboard do
  metrics
  chart :line
  filters
```

---

## The North Star

**Most expressive possible:**
```slim
== financial_app do
  calculator
  comparison
  projection
  recommendations
```

**One line creates an entire financial planning application.**

But we stop before it becomes:
- Too magical (violates POLA)
- Too implicit (hard to understand)
- Too inflexible (can't customize)

---

## Balancing Act

### ✅ Good Magic
```slim
== calculator :compound_interest, model: @calc
```
- Convention-based
- Still clear what it does
- Easy to override

### ❌ Too Much Magic
```slim
== app
```
- What does this do?
- No way to customize
- Violates "expression over specification"

---

## The Vision in One Sentence

**Slim-pickins templates should read like a conversation about what you want the UI to do, not a specification of how to build it.**

---

## Practical Next Steps

1. **Add more domain helpers**
   - `date_range_field`
   - `toggle_field`
   - `multiselect_field`
   - `slider_field`

2. **Implement Slim filters**
   - `currency:`, `percent:`, `date:`
   - `sparkline:`, `trend:`
   - `format:`, `truncate:`

3. **Create convention-based helpers**
   - `calculator` that infers field types
   - `dashboard` that layouts metrics
   - `comparison` that shows side-by-side

4. **Add more reactive patterns**
   - Inline editing
   - Auto-save
   - Optimistic updates

5. **Build component library**
   - Pre-built complex components
   - Customizable via options
   - Composable and nestable

**Be as good as bread.** 🍞

The ingredients are simple, but the combinations are infinite.
