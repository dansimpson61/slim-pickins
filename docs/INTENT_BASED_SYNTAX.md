# Intent-Based Syntax: Serve the Human, Not the Compiler

> **"Code should not require cryptic markings. Interpret liberally, fail gracefully."**

---

## The Philosophy

### ❌ Compiler-First (Bad)
```ruby
# Serving the compiler
toggle_region(:left, 'Scenario', {
  collapsible: true,
  default_state: :expanded,
  data: { controller: 'toggle', toggle_target: 'panel' }
})
```

**Problems:**
- Verbose ceremony
- Implementation details exposed
- Developer must remember exact syntax
- Hostile to humans

### ✅ Human-First (Good)
```slim
/ Serving the human
toggleleft 'Scenario'
  / Just write what you mean
```

**Benefits:**
- Reads like English
- Intent is clear
- Compiler does the work
- Joyful to write

---

## Your Example: Dashboard Layout

### What You Wrote:
```slim
### Your Intent-First Syntax:
```slim
toggleleft 'Scenario'

  toggletop @profiles do
    render _profile

  toggletop @assets do
    render _asset

  toggletop @flows do
    render _flow

  togglebottom @settings do
    render _settings
```

**Note the indentation!** Everything indented under `toggleleft` is INSIDE it.

### What You Mean:
```
┌──────────────────────┬──────────────────────────────┐
│ Scenario          ◀ │                              │
├──────────────────────┤                              │
│ Profiles         ▼   │                              │
├──────────────────────┤      Main content area       │
│ Assets           ▼   │                              │
├──────────────────────┤    (Content not yet          │
│ Flows            ▼   │     defined in the template) │
├──────────────────────┤                              │
│                      │                              │
├──────────────────────┤                              │
│ Settings         ▲   │                              │
└──────────────────────┴──────────────────────────────┘
          ↑                        ↑
    Left sidebar              Main area
  (contains all sections)   (shows active section)
```

**Structure:**
```
toggleleft 'Scenario'          ← Creates left sidebar
  ├─ toggletop @profiles       ← Section IN SIDEBAR
  ├─ toggletop @assets         ← Section IN SIDEBAR
  ├─ toggletop @flows          ← Section IN SIDEBAR
  └─ togglebottom @settings    ← Section IN SIDEBAR (bottom)

Main area shows content of whichever section is selected
```
```

### What You Mean:

```
┌──────────┬───────────────────────────────────────┐
│          │ [Profiles▼] [Assets▼] [Flows▼]       │
│          ├───────────────────────────────────────┤
│ Scenario │                                       │
│    ▼     │  Content area shows active tab        │
│          │  (profiles, assets, or flows)         │
│          │                                       │
│          ├───────────────────────────────────────┤
│          │ Settings ▼                            │
└──────────┴───────────────────────────────────────┘
```

### How Slim-Pickins Should Interpret It:

```ruby
# lib/helpers/layout_dsl_helpers.rb

module LayoutDSLHelpers
  # Left toggle panel - captures block context
  def toggleleft(title = nil, **opts, &block)
    content = capture_html(&block) if block
    
    <<~HTML
      <div class="layout-with-sidebar" data-controller="layout">
        <aside class="sidebar-left" data-layout-target="sidebarLeft">
          <div class="sidebar-header">
            <h3>#{title}</h3>
            <button data-action="click->layout#toggleLeft" class="toggle-btn">
              ◀
            </button>
          </div>
        </aside>
        
        <main class="main-content">
          #{content}
        </main>
      </div>
    HTML
  end
  
  # Top toggleable section (tab-like)
  def toggletop(collection, **opts, &block)
    label = collection.class.name.split('::').last.downcase rescue 'items'
    count = collection.respond_to?(:count) ? collection.count : 0
    
    <<~HTML
      <section class="toggle-section toggle-top" data-controller="collapsible">
        <header class="section-header" data-action="click->collapsible#toggle">
          <h4>#{label.capitalize}</h4>
          <span class="count badge">#{count}</span>
          <button class="toggle-indicator">▼</button>
        </header>
        
        <div class="section-content" data-collapsible-target="content">
          #{render_collection(collection, &block)}
        </div>
      </section>
    HTML
  end
  
  # Bottom toggle section (persistent footer)
  def togglebottom(data, **opts, &block)
    label = data.class.name.split('::').last.downcase rescue 'settings'
    
    <<~HTML
      <section class="toggle-section toggle-bottom" data-controller="collapsible">
        <header class="section-header" data-action="click->collapsible#toggle">
          <h4>#{label.capitalize}</h4>
          <button class="toggle-indicator">▲</button>
        </header>
        
        <div class="section-content" data-collapsible-target="content">
          #{block_given? ? capture_html(&block) : ''}
        </div>
      </section>
    HTML
  end
  
  # Helper to render collections with partials
  def render_collection(collection, &block)
    return '' unless collection.respond_to?(:each)
    
    collection.map do |item|
      block.call(item) if block_given?
    end.join
  end
end
```

### Generated HTML:

```html
### How Slim-Pickins *Should* Generate It:

```ruby
# lib/helpers/layout_dsl_helpers.rb

module LayoutDSLHelpers
  # Left sidebar layout - ALL sections go IN the sidebar
  def toggleleft(title = nil, **opts, &block)
    # The block contains ALL the toggletop/togglebottom sections
    # They all render INSIDE the sidebar
    sidebar_content = capture_html(&block) if block
    
    <<~HTML
      <div class="layout-with-sidebar" data-controller="layout">
        <aside class="sidebar-left" data-layout-target="sidebar">
          <div class="sidebar-header">
            <h3>#{title}</h3>
            <button data-action="click->layout#toggleSidebar" 
                    class="toggle-btn"
                    aria-label="Toggle sidebar">
              ◀
            </button>
          </div>
          
          <div class="sidebar-content">
            #{sidebar_content}
          </div>
        </aside>
        
        <main class="main-content" data-layout-target="main">
          <!-- Content from selected section appears here -->
          <div data-layout-target="activeContent"></div>
        </main>
      </div>
    HTML
  end
  
  # Top collapsible section - lives IN the sidebar
  # Clicking header shows content in main area
  def toggletop(collection, **opts, &block)
    label = infer_label(collection)
    count = collection.respond_to?(:count) ? collection.count : 0
    section_id = label.downcase.gsub(/\s+/, '-')
    
    # Capture the rendered content
    content = render_collection(collection, &block)
    
    <<~HTML
      <section class="sidebar-section section-top" 
               data-controller="sidebar-section"
               data-sidebar-section-id-value="#{section_id}"
               data-action="click->layout#showSection">
        <header class="section-header">
          <h4>#{label}</h4>
          <span class="count badge">#{count}</span>
          <button class="toggle-indicator" aria-hidden="true">▼</button>
        </header>
        
        <!-- Content stored but hidden, shown in main area when selected -->
        <template data-sidebar-section-target="content">
          #{content}
        </template>
      </section>
    HTML
  end
  
  # Bottom section - also lives IN the sidebar
  def togglebottom(data, **opts, &block)
    label = infer_label(data)
    section_id = label.downcase.gsub(/\s+/, '-')
    
    # Capture the rendered content
    content = block_given? ? capture_html(&block) : ''
    
    <<~HTML
      <section class="sidebar-section section-bottom" 
               data-controller="sidebar-section"
               data-sidebar-section-id-value="#{section_id}"
               data-action="click->layout#showSection">
        <header class="section-header">
          <h4>#{label}</h4>
          <button class="toggle-indicator" aria-hidden="true">▲</button>
        </header>
        
        <!-- Content stored but hidden, shown in main area when selected -->
        <template data-sidebar-section-target="content">
          #{content}
        </template>
      </section>
    HTML
  end
  
  # Helper to infer label from variable name
  def infer_label(data)
    if data.respond_to?(:model_name)
      data.model_name.human.pluralize
    elsif data.instance_variable_name
      data.instance_variable_name
        .to_s
        .gsub('@', '')
        .split('_')
        .map(&:capitalize)
        .join(' ')
    else
      data.class.name.split('::').last
    end
  rescue
    'Items'
  end
  
  # Helper to render collections with partials
  def render_collection(collection, &block)
    return '' unless collection.respond_to?(:each)
    
    collection.map do |item|
      block.call(item) if block_given?
    end.join
  end
  
  def capture_html(&block)
    if respond_to?(:capture)
      capture(&block)
    else
      yield if block_given?
    end
  end
end
```

### Generated HTML:

```html
<!-- toggleleft creates the overall two-column structure -->
<div class="layout-with-sidebar" data-controller="layout">
  
  <!-- Left sidebar - contains ALL the sections -->
  <aside class="sidebar-left" data-layout-target="sidebar">
    
    <!-- Sidebar header with collapse button -->
    <div class="sidebar-header">
      <h3>Scenario</h3>
      <button data-action="click->layout#toggleSidebar" 
              class="toggle-btn">◀</button>
    </div>
    
    <!-- Sidebar content - all sections render here -->
    <div class="sidebar-content">
      
      <!-- First toggletop section (in sidebar) -->
      <section class="sidebar-section section-top" 
               data-controller="sidebar-section"
               data-sidebar-section-id-value="profiles"
               data-action="click->layout#showSection">
        <header class="section-header">
          <h4>Profiles</h4>
          <span class="count badge">5</span>
          <button class="toggle-indicator">▼</button>
        </header>
        <template data-sidebar-section-target="content">
          <!-- @profiles content stored here, shown in main when clicked -->
          <div class="profile">Profile 1</div>
          <div class="profile">Profile 2</div>
          <!-- etc -->
        </template>
      </section>
      
      <!-- Second toggletop section (in sidebar) -->
      <section class="sidebar-section section-top" 
               data-controller="sidebar-section"
               data-sidebar-section-id-value="assets"
               data-action="click->layout#showSection">
        <header class="section-header">
          <h4>Assets</h4>
          <span class="count badge">12</span>
          <button class="toggle-indicator">▼</button>
        </header>
        <template data-sidebar-section-target="content">
          <!-- @assets content stored here -->
        </template>
      </section>
      
      <!-- Third toggletop section (in sidebar) -->
      <section class="sidebar-section section-top" 
               data-controller="sidebar-section"
               data-sidebar-section-id-value="flows"
               data-action="click->layout#showSection">
        <header class="section-header">
          <h4>Flows</h4>
          <span class="count badge">8</span>
          <button class="toggle-indicator">▼</button>
        </header>
        <template data-sidebar-section-target="content">
          <!-- @flows content stored here -->
        </template>
      </section>
      
      <!-- Bottom section (in sidebar, at bottom) -->
      <section class="sidebar-section section-bottom" 
               data-controller="sidebar-section"
               data-sidebar-section-id-value="settings"
               data-action="click->layout#showSection">
        <header class="section-header">
          <h4>Settings</h4>
          <button class="toggle-indicator">▲</button>
        </header>
        <template data-sidebar-section-target="content">
          <!-- @settings content stored here -->
        </template>
      </section>
      
    </div>
  </aside>
  
  <!-- Main content area - shows selected section's content -->
  <main class="main-content" data-layout-target="main">
    <div data-layout-target="activeContent">
      <!-- When you click a section header in sidebar, 
           its content appears here -->
    </div>
  </main>
  
</div>
```

### How It Works:

1. **Sidebar contains section headers** (Profiles, Assets, Flows, Settings)
2. **Each section stores its content** in a `<template>` tag
3. **Click a section header** → its content moves to main area
4. **Main area shows** the active section's full content
5. **Sidebar can collapse** with the ◀ button

**This is a navigation pattern!** Like VS Code's sidebar with different panels. ✨
```

---

## Liberal Interpretation Principles

### 1. Infer from Context

```slim
/ You write:
toggletop @profiles do
  render _profile

/ Slim-Pickins infers:
/ - @profiles is a collection (has count)
/ - Needs to iterate
/ - Should show count badge
/ - Block receives each item
/ - Partial name from singular form
```

### 2. Smart Defaults

```slim
/ You write minimal:
toggleleft 'Scenario'

/ Slim-Pickins provides:
/ - Collapsible behavior (Stimulus controller)
/ - Toggle button with icon
/ - Proper ARIA attributes
/ - Responsive breakpoints
/ - Keyboard navigation
```

### 3. Graceful Degradation

```slim
/ If collection is empty:
toggletop @profiles do
  render _profile

/ Shows:
/ Profiles (0)
/   [Empty state message]
/   "No profiles yet. Add your first profile."
```

### 4. Forgiving Syntax

```slim
/ All of these should work:
toggleleft 'Scenario'
toggleleft "Scenario"
toggleleft :scenario
toggleleft scenario: "My Scenario"

/ And these:
toggletop @profiles
toggletop @profiles do |profile|
  render partial: 'profile', locals: { profile: profile }
toggletop profiles: @profiles
```

---

## More Intent-Based Patterns

### Pattern 1: Timeline View

```slim
/ Your intent:
timeline @events do
  event_card
```

**Interprets as:**
- Vertical timeline layout
- Each event gets timestamp
- Connectors between events
- Auto-groups by date

### Pattern 2: Kanban Board

```slim
/ Your intent:
kanban @tasks, columns: [:todo, :doing, :done]
```

**Interprets as:**
- 3-column layout
- Drag-and-drop enabled
- Task counts in headers
- Status updates on drop

### Pattern 3: Split View

```slim
/ Your intent:
split
  left @document
    render editor
  
  right @preview
    render preview
```

**Interprets as:**
- Resizable split pane
- Left/right sections
- Drag handle between
- Remembers size preference

### Pattern 4: Master-Detail

```slim
/ Your intent:
master @users do
  render _user_row

detail @selected_user do
  render _user_detail
```

**Interprets as:**
- List on left, detail on right
- Click item → shows detail
- Keyboard navigation (arrows)
- Mobile: full-screen detail

### Pattern 5: Wizard Flow

```slim
/ Your intent:
wizard "Onboarding"
  
  step "Account"
    render account_form
  
  step "Profile"
    render profile_form
  
  step "Review"
    render review
```

**Interprets as:**
- Progress indicator
- Next/Back buttons
- Validation per step
- Can't skip ahead
- Saves draft state

---

## The "Render" Convention

### Liberal Interpretation of `render`

```slim
/ You write:
render _profile

/ Could mean any of:
render partial: 'profile'
render partial: 'profile', locals: { profile: profile }
render template: 'profile'
render @profile  # if @profile is an object
```

**Slim-Pickins should:**
1. Check if `_profile` is a partial (views/_profile.slim)
2. Check if `profile` is a variable in scope
3. Auto-pass iteration variable if in loop
4. Fall back gracefully with helpful error

### Smart Partial Resolution

```slim
toggletop @profiles do
  render _profile

/ Slim-Pickins looks for:
/ 1. views/_profile.slim (most common)
/ 2. views/profiles/_profile.slim (namespaced)
/ 3. views/shared/_profile.slim (shared)
/ 
/ Auto-passes:
/ locals: { profile: profile }  # iteration variable
```

---

## Graceful Failure Examples

### Missing Partial

```slim
toggletop @profiles do
  render _profile
```

**If _profile.slim doesn't exist:**

```
┌────────────────────────────────────────────────────┐
│ ⚠️  Partial not found: _profile                    │
│                                                    │
│ Slim-Pickins looked in:                           │
│   • views/_profile.slim                           │
│   • views/profiles/_profile.slim                  │
│   • views/shared/_profile.slim                    │
│                                                    │
│ Quick fix:                                        │
│   Create views/_profile.slim with:                │
│                                                    │
│   .profile                                        │
│     h3 = profile.name                             │
│     p = profile.bio                               │
│                                                    │
│ Or pass explicit partial path:                    │
│   render partial: 'shared/profile'                │
└────────────────────────────────────────────────────┘
```

**NOT:**
```
NoMethodError: undefined method `render' for _profile
```

### Empty Collection

```slim
toggletop @profiles do
  render _profile
```

**If @profiles is empty:**

Shows elegant empty state:
```
┌────────────────────────────────────┐
│ Profiles (0)                    ▼  │
├────────────────────────────────────┤
│                                    │
│        📋                          │
│                                    │
│     No profiles yet                │
│                                    │
│  [Add your first profile]          │
│                                    │
└────────────────────────────────────┘
```

### Nil Collection

```slim
toggletop @profiles do
  render _profile
```

**If @profiles is nil:**

Helpful development error:
```
┌────────────────────────────────────────────────────┐
│ ⚠️  Variable @profiles is nil                      │
│                                                    │
│ Did you forget to set it in your controller?      │
│                                                    │
│ Add to your action:                               │
│   @profiles = Profile.all                         │
│                                                    │
│ Or pass an empty array as default:                │
│   @profiles ||= []                                │
└────────────────────────────────────────────────────┘
```

---

## Implementation Strategy

### Phase 1: Parse Intent
```ruby
def toggletop(data, **opts, &block)
  # Detect what data is
  if data.respond_to?(:each)
    # It's a collection
    render_collection_toggle(data, &block)
  elsif data.is_a?(Symbol) || data.is_a?(String)
    # It's a label
    render_labeled_toggle(data, &block)
  else
    # It's a single object
    render_item_toggle(data, &block)
  end
end
```

### Phase 2: Infer Requirements
```ruby
def render_collection_toggle(collection, &block)
  label = infer_label(collection)
  count = safe_count(collection)
  empty_message = generate_empty_state(label)
  partial = infer_partial_name(collection)
  
  # Build component with inferred data
end

def infer_label(collection)
  # @profiles → "Profiles"
  # @user_profiles → "User Profiles"
  collection.instance_variable_name
    .to_s
    .gsub('@', '')
    .split('_')
    .map(&:capitalize)
    .join(' ')
end
```

### Phase 3: Provide Defaults
```ruby
DEFAULTS = {
  toggle_icon: '▼',
  empty_icon: '📋',
  animation: 'slide',
  duration: 300,
  remember_state: true
}
```

### Phase 4: Generate Output
```ruby
def generate_html(options)
  <<~HTML
    <section data-controller="collapsible">
      #{header(options)}
      #{content(options)}
    </section>
  HTML
end
```

---

## The Liberal Interpretation Matrix

| You Write | Slim-Pickins Interprets | Provides |
|-----------|------------------------|----------|
| `toggleleft 'Title'` | Collapsible sidebar | Toggle button, animation, state |
| `toggletop @items` | Expandable section | Header, count, empty state |
| `render _partial` | Include partial | Auto-find, auto-pass locals |
| `split` | Two-pane layout | Resize handle, breakpoints |
| `tabs a: "A", b: "B"` | Tabbed interface | Active state, keyboard nav |
| `wizard` | Multi-step form | Progress, validation, draft |
| `master @list` | List-detail view | Selection state, responsive |

---

## Error Messages That Teach

### ❌ Cryptic (Bad)
```
NoMethodError: undefined method `toggletop'
```

### ✅ Helpful (Good)
```
┌────────────────────────────────────────────────────┐
│ ⚠️  Unknown helper: toggletop                      │
│                                                    │
│ This looks like a layout helper. Did you mean:    │
│   • togglesection (collapsible section)           │
│   • collapsible (generic collapsible)             │
│   • accordion_item (accordion section)            │
│                                                    │
│ Or add layout helpers to your Gemfile:            │
│   gem 'slim-pickins-layouts'                      │
│                                                    │
│ Learn more:                                       │
│   docs/LAYOUT_HELPERS.md                          │
└────────────────────────────────────────────────────┘
```

---

## Your Syntax in Full Context

```slim
/ views/dashboard.slim

h1 Project Dashboard

/ Intent-based layout - reads like a spec!
toggleleft 'Scenario'

  / Top sections - toggleable tabs
  toggletop @profiles do
    / Each profile renders with partial
    render _profile

  toggletop @assets do
    / Each asset renders with partial
    render _asset

  toggletop @flows do
    / Each flow renders with partial
    render _flow

  / Bottom section - persistent but collapsible
  togglebottom @settings do
    / Settings panel
    render _settings
```

**What Slim-Pickins generates:**
- Complete HTML structure ✓
- Stimulus controllers wired ✓
- Responsive breakpoints ✓
- Keyboard navigation ✓
- ARIA attributes ✓
- Empty states ✓
- Loading states ✓
- Error handling ✓

**What you didn't have to write:**
- Data attributes (0)
- Controller names (0)
- Action bindings (0)
- Target definitions (0)
- CSS classes (0)
- JavaScript (0 lines)

**That's ~150 lines → 13 lines. That's joy.** ✨

---

## The North Star

**Perfect Intent:**
```slim
dashboard
  sidebar 'Scenario'
  sections @profiles, @assets, @flows
  footer @settings
```

**One day.** 🌟

**Today:**
```slim
toggleleft 'Scenario'
  toggletop @profiles do render _profile
  toggletop @assets do render _asset
  toggletop @flows do render _flow
  togglebottom @settings do render _settings
```

**Already beautiful.** 🍞

---

## Be as good as bread

**Code should:**
- Serve humans, not compilers
- Interpret liberally
- Fail gracefully
- Teach, don't punish
- Infer intent
- Provide defaults
- Hide ceremony

**This is the Slim-Pickins way.** ✨
