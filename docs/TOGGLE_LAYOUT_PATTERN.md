# Toggle Layout Pattern: The Correct Interpretation

> **Understanding the spatial layout DSL with proper rendering**

---

## The Code You Write

```slim
toggleleft 'Scenario'

  toggletop @profiles do
    render _profile

  toggletop @assets do
    render _asset

  toggletop @flows do
    render _flow

  togglebottom @settings
    render _settings
```

---

## How It Works

### 1. String Parameter = Label
```slim
toggleleft 'Scenario'
```
- **'Scenario'** is a string → used as the sidebar header label
- Creates left sidebar with "Scenario" as the title

### 2. With `do` Block = Iterate Over Collection
```slim
toggletop @profiles do
  render _profile
```
- **@profiles** is enumerable → iterate over each item
- **do...end** block receives each profile
- **render _profile** renders partial for each profile
- Content goes **INSIDE** the toggletop section in the sidebar

### 3. Without `do` Block = Render Once
```slim
togglebottom @settings
  render _settings
```
- **@settings** is a single object (not iterated)
- **No do block** → just render the partial once
- Content goes **INSIDE** the togglebottom section

---

## Visual Structure

```
┌──────────────────────┬────────────────────────────┐
│ Scenario          ◀  │                            │
├──────────────────────┤                            │
│ Profiles (5)      ▼  │                            │
│  └─ Profile 1        │                            │
│  └─ Profile 2        │      Main content area     │
│  └─ Profile 3        │                            │
├──────────────────────┤   (Shows selected section  │
│ Assets (3)        ▼  │    content when clicked)   │
│  └─ Asset 1          │                            │
│  └─ Asset 2          │                            │
├──────────────────────┤                            │
│ Flows (2)         ▼  │                            │
│  └─ Flow 1           │                            │
│  └─ Flow 2           │                            │
├──────────────────────┤                            │
│                      │                            │
├──────────────────────┤                            │
│ Settings          ▲  │                            │
│  └─ Settings form    │                            │
└──────────────────────┴────────────────────────────┘
```

**Structure Breakdown:**

1. **toggleleft 'Scenario'** → Creates left sidebar with header "Scenario"
2. **Sidebar contains:**
   - **toggletop @profiles do** → Collapsible section with 5 profiles listed
   - **toggletop @assets do** → Collapsible section with 3 assets listed
   - **toggletop @flows do** → Collapsible section with 2 flows listed
   - **togglebottom @settings** → Collapsible section with settings form
3. **Main area** → Shows expanded content when section is active

---

## Implementation

### The Helper

```ruby
module LayoutDSLHelpers
  # Creates left sidebar layout
  def toggleleft(title = nil, **opts, &block)
    sidebar_content = capture_html(&block) if block
    
    <<~HTML
      <div class="layout-with-sidebar" data-controller="layout">
        <aside class="sidebar-left" data-layout-target="sidebar">
          <div class="sidebar-header">
            <h3>#{title}</h3>
            <button data-action="click->layout#toggleSidebar">◀</button>
          </div>
          <div class="sidebar-content">
            #{sidebar_content}
          </div>
        </aside>
        <main class="main-content" data-layout-target="main"></main>
      </div>
    HTML
  end
  
  # Creates collapsible section with iteration
  def toggletop(collection, **opts, &block)
    label = infer_label(collection)
    count = collection.respond_to?(:count) ? collection.count : 0
    
    # Render content INSIDE the section
    content = if block_given? && collection.respond_to?(:each)
                # Iterate and render for each item
                collection.map { |item| capture_html { block.call(item) } }.join
              elsif block_given?
                # Single render
                capture_html(&block)
              else
                ''
              end
    
    <<~HTML
      <section class="sidebar-section section-top" data-controller="collapsible">
        <header class="section-header" data-action="click->collapsible#toggle">
          <h4>#{label}</h4>
          <span class="count badge">#{count}</span>
          <button class="toggle-indicator">▼</button>
        </header>
        <div class="section-content" data-collapsible-target="content">
          #{content}
        </div>
      </section>
    HTML
  end
  
  # Creates bottom section (no iteration, single content)
  def togglebottom(data, **opts, &block)
    label = infer_label(data)
    
    # Render content INSIDE the section (no iteration)
    content = block_given? ? capture_html(&block) : ''
    
    <<~HTML
      <section class="sidebar-section section-bottom" data-controller="collapsible">
        <header class="section-header" data-action="click->collapsible#toggle">
          <h4>#{label}</h4>
          <button class="toggle-indicator">▲</button>
        </header>
        <div class="section-content" data-collapsible-target="content">
          #{content}
        </div>
      </section>
    HTML
  end
  
  def infer_label(data)
    if data.respond_to?(:model_name)
      data.model_name.human.pluralize
    elsif data.instance_variable_name
      data.instance_variable_name.to_s.gsub('@', '').split('_').map(&:capitalize).join(' ')
    else
      data.class.name.split('::').last
    end
  rescue
    'Items'
  end
  
  def capture_html(&block)
    respond_to?(:capture) ? capture(&block) : yield
  end
end
```

---

## Generated HTML

```html
<div class="layout-with-sidebar" data-controller="layout">
  
  <!-- Left Sidebar -->
  <aside class="sidebar-left" data-layout-target="sidebar">
    
    <!-- Sidebar Header -->
    <div class="sidebar-header">
      <h3>Scenario</h3>
      <button data-action="click->layout#toggleSidebar">◀</button>
    </div>
    
    <!-- Sidebar Content -->
    <div class="sidebar-content">
      
      <!-- Profiles Section (with iteration) -->
      <section class="sidebar-section section-top" data-controller="collapsible">
        <header class="section-header" data-action="click->collapsible#toggle">
          <h4>Profiles</h4>
          <span class="count badge">5</span>
          <button class="toggle-indicator">▼</button>
        </header>
        <div class="section-content" data-collapsible-target="content">
          <!-- Each @profile rendered with _profile partial -->
          <div class="profile">Profile 1 content...</div>
          <div class="profile">Profile 2 content...</div>
          <div class="profile">Profile 3 content...</div>
          <div class="profile">Profile 4 content...</div>
          <div class="profile">Profile 5 content...</div>
        </div>
      </section>
      
      <!-- Assets Section (with iteration) -->
      <section class="sidebar-section section-top" data-controller="collapsible">
        <header class="section-header" data-action="click->collapsible#toggle">
          <h4>Assets</h4>
          <span class="count badge">3</span>
          <button class="toggle-indicator">▼</button>
        </header>
        <div class="section-content" data-collapsible-target="content">
          <!-- Each @asset rendered with _asset partial -->
          <div class="asset">Asset 1 content...</div>
          <div class="asset">Asset 2 content...</div>
          <div class="asset">Asset 3 content...</div>
        </div>
      </section>
      
      <!-- Flows Section (with iteration) -->
      <section class="sidebar-section section-top" data-controller="collapsible">
        <header class="section-header" data-action="click->collapsible#toggle">
          <h4>Flows</h4>
          <span class="count badge">2</span>
          <button class="toggle-indicator">▼</button>
        </header>
        <div class="section-content" data-collapsible-target="content">
          <!-- Each @flow rendered with _flow partial -->
          <div class="flow">Flow 1 content...</div>
          <div class="flow">Flow 2 content...</div>
        </div>
      </section>
      
      <!-- Settings Section (NO iteration, single render) -->
      <section class="sidebar-section section-bottom" data-controller="collapsible">
        <header class="section-header" data-action="click->collapsible#toggle">
          <h4>Settings</h4>
          <button class="toggle-indicator">▲</button>
        </header>
        <div class="section-content" data-collapsible-target="content">
          <!-- _settings partial rendered once -->
          <form class="settings-form">
            ...settings form content...
          </form>
        </div>
      </section>
      
    </div>
  </aside>
  
  <!-- Main Content Area -->
  <main class="main-content" data-layout-target="main">
    <!-- Could be used for detail view when item is clicked -->
  </main>
  
</div>
```

---

## Key Differences

### With `do` Block (Iteration)
```slim
toggletop @profiles do
  render _profile
```

**Result:** 
- Iterates over `@profiles`
- Each profile gets passed to the block
- `_profile` partial rendered for EACH item
- All rendered inside the section

### Without `do` Block (Single Render)
```slim
togglebottom @settings
  render _settings
```

**Result:**
- No iteration
- `_settings` partial rendered ONCE
- Content inside the section

### String Parameter (Label)
```slim
toggleleft 'Scenario'
```

**Result:**
- String used as label/title
- No data processing
- Pure display text

---

## Usage Patterns

### Pattern 1: List of Items
```slim
toggletop @users do
  render _user_card
```
→ Shows collapsible list of user cards in sidebar

### Pattern 2: Single Form/Content
```slim
togglebottom @settings
  render _settings_form
```
→ Shows settings form once in bottom section

### Pattern 3: Nested Content
```slim
toggleleft 'Projects'
  
  toggletop @active_projects do
    .project
      h4 = project.name
      p = project.status
  
  toggletop @archived_projects do
    .project.archived
      h4 = project.name
```
→ Inline rendering without partials

### Pattern 4: Mixed Content
```slim
toggleleft 'Dashboard'
  
  toggletop @tasks do
    == task_card task
  
  togglebottom @quick_actions
    .actions
      == button "New Task"
      == button "Import"
```
→ Mix of iteration and single content

---

## The Beauty

**Your code:**
```slim
toggleleft 'Scenario'
  toggletop @profiles do
    render _profile
  toggletop @assets do
    render _asset
  toggletop @flows do
    render _flow
  togglebottom @settings
    render _settings
```

**Reads like a spec:**
- "Create a left sidebar labeled 'Scenario'"
- "Add a collapsible section for profiles (iterate and show each)"
- "Add a collapsible section for assets (iterate and show each)"
- "Add a collapsible section for flows (iterate and show each)"
- "Add a bottom section for settings (show once)"

**No data attributes. No wiring. No ceremony.** 

Just pure spatial intent. 🍞✨
