# Toggle Panel System: Complete Specification

> **A unified, CSS-first approach to collapsible panels**

---

## Core Concept

**`togglepanel`** is the base helper with a `:position` parameter.

**Convenience aliases** are shorthand for common positions:
- `toggleleft` → `togglepanel position: :left`
- `toggleright` → `togglepanel position: :right`
- `toggletop` → `togglepanel position: :top`
- `togglebottom` → `togglepanel position: :bottom`

---

## Positioning Rules

### 1. Edge Alignment
Panels stick to the edge of their **container**:
- `toggleleft` → sticks to left edge
- `toggleright` → sticks to right edge
- `toggletop` → sticks to top edge
- `togglebottom` → sticks to bottom edge

### 2. Sizing
- **100% of the edge** they're attached to
- `toggleleft/right` → height: 100% of container
- `toggletop/bottom` → width: 100% of container

### 3. Content Flow
**Adjacent page sections automatically flow to accommodate toggle panels.**

When a panel expands or collapses, the main content area adjusts:
- **Left panel expands** → content shifts right, narrows
- **Right panel expands** → content shifts left, narrows
- **Top panel expands** → content shifts down
- **Bottom panel expands** → content shifts up

**Why this matters:**
- Users can keep a panel open while working in another area
- Multiple panels can be open simultaneously
- Content remains visible and accessible
- Natural, intuitive layout behavior

### 4. Layout Context Matters

#### In `layout.slim` → Fixed Position
```slim
/ views/layout.slim
doctype html
html
  body
    toggleleft 'Navigation'
      / This is FIXED on screen
      / Stays visible while content scrolls
```
**Result:** `position: fixed` (stays on screen)

#### In Other Templates → Scrolls with Container
```slim
/ views/dashboard.slim
.container
  toggleright 'Filters'
    / This SCROLLS with .container
    / Moves when user scrolls
```
**Result:** `position: absolute` or `sticky` (scrolls with container)

---

## Interaction Behavior

### Toggle on Click
**All panels toggle open/closed when clicked:**
- Click header → panel opens
- Click header again → panel closes
- Smooth animation
- State persists (optional)

### Collapsed State Display

#### Top & Bottom Panels (Horizontal)
**When collapsed:**
```
┌────────────────────────────────────────┐
│ [Icon] Label                         ▼ │
└────────────────────────────────────────┘
```
- Shows **icon** (left-aligned)
- Shows **label** (left-aligned, next to icon)
- Shows **toggle indicator** (▼/▲, right-aligned)
- Full width, minimal height

#### Left & Right Panels (Vertical)
**When collapsed:**
```
┌───┐
│ 📋 │  ← Icon only
├───┤
│   │
│ ▶ │  ← Toggle indicator
│   │
└───┘
```
- Shows **icon only** (rotated/vertical text optional)
- Shows **toggle indicator** (◀/▶)
- Full height, minimal width (~40px)
- Label hidden when collapsed

---

## CSS-First Implementation

### Principles
1. **Integrate, don't duplicate** - Reuse existing Slim-Pickins tokens
2. **Use modern CSS** for layout and behavior
3. **Minimal JavaScript** - only for toggle state
4. **CSS animations** for smooth transitions
5. **CSS grid/flexbox** for positioning
6. **Semantic tokens** over magic numbers

### Token Reuse Strategy

**What we DON'T add:**
- ❌ Panel-specific colors (use `--paper-*`, `--ink-*`, `--accent-*`)
- ❌ Panel-specific spacing (use `--sp-*`, `--pad-*`, `--gap-*`)
- ❌ Panel-specific typography (use `--fs-*`, `--fw-*`)
- ❌ Panel-specific shadows (use `--shadow-soft`)
- ❌ Panel-specific borders (use `--border-thin`, `--border-default`)
- ❌ Panel-specific radius (use `--radius-whisper`)
- ❌ Panel-specific transitions (use consistent 300ms)

**What we DO add (only 4 tokens):**
- ✅ `--panel-width` - Unique to panel sizing
- ✅ `--panel-height` - Unique to panel sizing
- ✅ `--panel-collapsed` - Unique to panel sizing
- ✅ `--panel-z` - Unique to panel layering

**Result:** ~4 new tokens instead of ~20. Clear, maintainable, consistent.

### CSS Structure

**Uses existing Slim-Pickins tokens for consistency, clarity, and maintainability.**

```css
/**
 * Toggle Panel System
 * Integrates with slim-pickins-tokens.css
 * Uses existing spacing, colors, shadows, and transitions
 */

/* Panel-specific tokens (minimal additions) */
:root {
  --panel-width: 280px;           /* Default expanded width */
  --panel-height: 200px;          /* Default expanded height */
  --panel-collapsed: 2.5rem;      /* 40px - collapsed size */
  --panel-z: 100;                 /* Base z-index */
  --panel-transition: 300ms ease-in-out;
}

/* Base toggle panel - leverages existing tokens */
.toggle-panel {
  position: absolute;
  
  /* Use existing transition duration */
  transition: all var(--panel-transition);
  
  /* Use existing border, shadow, and color tokens */
  border: var(--border-thin) solid var(--border-default);
  box-shadow: var(--shadow-soft);
  background: var(--paper-0);
  z-index: var(--panel-z);
  
  /* Use existing border radius */
  border-radius: var(--radius-whisper);
}

/* Position-specific layouts */
.toggle-panel-left {
  left: 0;
  top: 0;
  height: 100%;
  width: var(--panel-width);
  border-left: none;
  border-radius: 0 var(--radius-whisper) var(--radius-whisper) 0;
}

.toggle-panel-left.collapsed {
  width: var(--panel-collapsed);
}

.toggle-panel-right {
  right: 0;
  top: 0;
  height: 100%;
  width: var(--panel-width);
  border-right: none;
  border-radius: var(--radius-whisper) 0 0 var(--radius-whisper);
}

.toggle-panel-right.collapsed {
  width: var(--panel-collapsed);
}

.toggle-panel-top {
  top: 0;
  left: 0;
  width: 100%;
  height: var(--panel-height);
  border-top: none;
  border-radius: 0 0 var(--radius-whisper) var(--radius-whisper);
}

.toggle-panel-top.collapsed {
  height: var(--panel-collapsed);
}

.toggle-panel-bottom {
  bottom: 0;
  left: 0;
  width: 100%;
  height: var(--panel-height);
  border-bottom: none;
  border-radius: var(--radius-whisper) var(--radius-whisper) 0 0;
}

.toggle-panel-bottom.collapsed {
  height: var(--panel-collapsed);
}

/* Fixed positioning in layout.slim */
body > .toggle-panel {
  position: fixed;
}

/* Content flow - uses existing spacing tokens */
body > .toggle-panel-left ~ main,
body > .toggle-panel-left ~ .content {
  margin-left: var(--panel-width);
  transition: margin-left var(--panel-transition);
}

body > .toggle-panel-left.collapsed ~ main,
body > .toggle-panel-left.collapsed ~ .content {
  margin-left: var(--panel-collapsed);
}

body > .toggle-panel-right ~ main,
body > .toggle-panel-right ~ .content {
  margin-right: var(--panel-width);
  transition: margin-right var(--panel-transition);
}

body > .toggle-panel-right.collapsed ~ main,
body > .toggle-panel-right.collapsed ~ .content {
  margin-right: var(--panel-collapsed);
}

body > .toggle-panel-top ~ main,
body > .toggle-panel-top ~ .content {
  margin-top: var(--panel-height);
  transition: margin-top var(--panel-transition);
}

body > .toggle-panel-top.collapsed ~ main,
body > .toggle-panel-top.collapsed ~ .content {
  margin-top: var(--panel-collapsed);
}

body > .toggle-panel-bottom ~ main,
body > .toggle-panel-bottom ~ .content {
  margin-bottom: var(--panel-height);
  transition: margin-bottom var(--panel-transition);
}

body > .toggle-panel-bottom.collapsed ~ main,
body > .toggle-panel-bottom.collapsed ~ .content {
  margin-bottom: var(--panel-collapsed);
}

/* Content visibility using existing display utilities */
.toggle-panel.collapsed .panel-content {
  display: none;
}

.toggle-panel-left.collapsed .panel-label,
.toggle-panel-right.collapsed .panel-label {
  display: none;
}

/* Header - uses existing spacing and color tokens */
.panel-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  
  /* Use existing padding tokens */
  padding: var(--pad-md);
  
  /* Use existing color tokens */
  border-bottom: var(--border-thin) solid var(--border-muted);
  
  /* Interaction */
  cursor: pointer;
  user-select: none;
}

.panel-header:hover {
  /* Use existing hover background */
  background: var(--hover-bg);
}

.panel-header:focus-visible {
  /* Use existing focus tokens */
  outline: var(--focus-width) solid var(--focus-ring);
  outline-offset: var(--focus-offset);
}

/* Collapsed header has less padding */
.toggle-panel.collapsed .panel-header {
  padding: var(--pad-sm);
  border-bottom: none;
}

/* Icon and label layout - uses existing spacing */
.panel-header-start {
  display: flex;
  align-items: center;
  gap: var(--gap-cluster);
}

.panel-icon {
  font-size: var(--fs-20);
  line-height: 1;
  flex-shrink: 0;
}

.panel-label {
  font-weight: var(--fw-medium);
  color: var(--ink-700);
  font-size: var(--fs-14);
}

.toggle-indicator {
  /* Use existing button reset patterns */
  background: none;
  border: none;
  padding: var(--pad-xs);
  color: var(--ink-500);
  cursor: pointer;
  font-size: var(--fs-16);
  line-height: 1;
  transition: color 150ms ease;
}

.toggle-indicator:hover {
  color: var(--accent-600);
}

/* Panel content - uses existing spacing */
.panel-content {
  padding: var(--pad-lg);
  overflow-y: auto;
  /* Calculate height minus header */
  height: calc(100% - 3rem);
}

/* Horizontal panels - different header layout */
.toggle-panel-top .panel-header,
.toggle-panel-bottom .panel-header {
  flex-direction: row;
}

/* Vertical panels - stack when expanded, minimal when collapsed */
.toggle-panel-left .panel-header,
.toggle-panel-right .panel-header {
  flex-direction: column;
  text-align: center;
  gap: var(--gap-cluster);
}

.toggle-panel-left.collapsed .panel-header,
.toggle-panel-right.collapsed .panel-header {
  gap: var(--sp-4);
}

/* Print: hide panels by default */
@media print {
  .toggle-panel {
    display: none;
  }
  
  /* Restore content margins */
  body > .toggle-panel ~ main,
  body > .toggle-panel ~ .content {
    margin: 0 !important;
  }
}

/* Reduced motion */
@media (prefers-reduced-motion: reduce) {
  .toggle-panel {
    transition: none;
  }
}
```

**Key Integration Points:**

1. **Spacing**: Uses `--sp-*`, `--pad-*`, `--gap-*` tokens
2. **Colors**: Uses `--paper-*`, `--ink-*`, `--border-*`, `--accent-*` tokens
3. **Typography**: Uses `--fs-*`, `--fw-*`, `--lh-*` tokens
4. **Shadows**: Uses existing `--shadow-soft` token
5. **Borders**: Uses `--border-thin`, `--border-default`, `--border-muted`
6. **Radius**: Uses `--radius-whisper` for subtle corners
7. **Focus**: Uses `--focus-ring`, `--focus-width`, `--focus-offset`
8. **Transitions**: Consistent timing with existing system
9. **Print styles**: Hides panels, restores layout
10. **Accessibility**: Respects `prefers-reduced-motion`

---

## Implementation

### The Base Helper

```ruby
module TogglePanelHelpers
  def togglepanel(title = nil, position: :left, icon: nil, **opts, &block)
    content = capture_html(&block) if block
    
    # Determine if this is in layout.slim (fixed) or not (scrollable)
    position_class = in_layout? ? 'fixed' : 'scrollable'
    
    # Infer icon if not provided
    icon_html = icon ? icon_tag(icon) : default_icon_for_position(position)
    
    # Generate unique ID for state management
    panel_id = opts[:id] || "panel-#{title.to_s.parameterize}"
    
    <<~HTML
      <aside class="toggle-panel toggle-panel-#{position} #{position_class}"
             id="#{panel_id}"
             data-controller="toggle-panel"
             data-toggle-panel-position-value="#{position}">
        
        <header class="panel-header" 
                data-action="click->toggle-panel#toggle"
                role="button"
                tabindex="0"
                aria-expanded="true"
                aria-controls="#{panel_id}-content">
          
          <div class="panel-header-start">
            #{icon_html}
            <span class="panel-label">#{title}</span>
          </div>
          
          <button class="toggle-indicator" aria-hidden="true">
            #{toggle_indicator(position)}
          </button>
        </header>
        
        <div class="panel-content" 
             id="#{panel_id}-content"
             data-toggle-panel-target="content">
          #{content}
        </div>
      </aside>
    HTML
  end
  
  # Convenience aliases
  def toggleleft(title = nil, **opts, &block)
    togglepanel(title, position: :left, **opts, &block)
  end
  
  def toggleright(title = nil, **opts, &block)
    togglepanel(title, position: :right, **opts, &block)
  end
  
  def toggletop(title = nil, **opts, &block)
    togglepanel(title, position: :top, **opts, &block)
  end
  
  def togglebottom(title = nil, **opts, &block)
    togglepanel(title, position: :bottom, **opts, &block)
  end
  
  private
  
  def in_layout?
    # Detect if we're rendering layout.slim
    # This is a simplified check - actual implementation may vary
    caller.any? { |line| line.include?('layout.slim') }
  end
  
  def icon_tag(icon)
    %(<span class="panel-icon">#{icon}</span>)
  end
  
  def default_icon_for_position(position)
    icons = {
      left: '📋',
      right: '⚙️',
      top: '📊',
      bottom: '🔧'
    }
    icon_tag(icons[position] || '●')
  end
  
  def toggle_indicator(position)
    case position
    when :left then '◀'
    when :right then '▶'
    when :top then '▲'
    when :bottom then '▼'
    end
  end
  
  def capture_html(&block)
    respond_to?(:capture) ? capture(&block) : yield
  end
end
```

### The Stimulus Controller

```javascript
// toggle_panel_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content"]
  static values = { position: String }
  
  connect() {
    // Restore saved state from localStorage
    this.restoreState()
  }
  
  toggle(event) {
    // Prevent default if it's a button
    event.preventDefault()
    
    // Toggle collapsed class
    this.element.classList.toggle('collapsed')
    
    // Update ARIA
    const expanded = !this.element.classList.contains('collapsed')
    const header = this.element.querySelector('.panel-header')
    header.setAttribute('aria-expanded', expanded)
    
    // Save state
    this.saveState()
  }
  
  saveState() {
    const collapsed = this.element.classList.contains('collapsed')
    localStorage.setItem(
      `toggle-panel-${this.element.id}`,
      collapsed ? 'collapsed' : 'expanded'
    )
  }
  
  restoreState() {
    const state = localStorage.getItem(`toggle-panel-${this.element.id}`)
    if (state === 'collapsed') {
      this.element.classList.add('collapsed')
      const header = this.element.querySelector('.panel-header')
      header?.setAttribute('aria-expanded', 'false')
    }
  }
}
```

---

## Usage Examples

### Example 1: Layout with Fixed Panels

```slim
/ views/layout.slim
doctype html
html
  head
    title My App
    link rel="stylesheet" href="/assets/stylesheets/slim-pickins.css"
  
  body
    / Fixed left navigation
    toggleleft 'Navigation', icon: '🧭'
      nav
        == nav_link "Dashboard", "/"
        == nav_link "Projects", "/projects"
        == nav_link "Settings", "/settings"
    
    / Fixed right panel
    toggleright 'Tools', icon: '🔧'
      .tools
        h4 Quick Actions
        == button "New Project"
        == button "Import"
    
    / Main content
    main.content
      == yield
```

**Result:**
- Left panel: Fixed to screen, always visible
- Right panel: Fixed to screen, always visible
- Content scrolls between them

### Example 2: Dashboard with Scrolling Panels

```slim
/ views/dashboard.slim
.dashboard-container
  
  / Scrolls with container
  toggletop 'Filters', icon: '🔍'
    .filters
      == field :search
      == field :category
      == field :date_range
  
  / Main dashboard content
  .dashboard-content
    / Your charts, metrics, etc.
  
  / Scrolls with container
  togglebottom 'Details', icon: '📊'
    .details
      / Additional info
```

**Result:**
- Top panel: Scrolls with .dashboard-container
- Bottom panel: Scrolls with .dashboard-container
- Everything moves together when scrolling

### Example 3: Collapsible Sidebar Sections

```slim
/ views/projects.slim
toggleleft 'Projects'
  
  / Each section can be a nested panel or just content
  section.project-section
    h4 Active Projects
    - @active_projects.each do |project|
      .project-item = project.name
  
  section.project-section
    h4 Archived Projects
    - @archived_projects.each do |project|
      .project-item = project.name
```

### Example 4: Multi-Panel Layout

```slim
/ views/editor.slim
.editor-layout
  
  / Left: File tree
  toggleleft 'Files', icon: '📁'
    .file-tree
      / File browser
  
  / Main: Editor
  .editor-main
    / Code editor
  
  / Right: Properties
  toggleright 'Properties', icon: '⚙️'
    .properties
      / Property inspector
  
  / Bottom: Console
  togglebottom 'Console', icon: '💻'
    .console
      / Terminal/console output
```

---

## Visual Examples

### Content Flow Behavior

**All panels closed:**
```
┌────────────────────────────────────────────────────┐
│                                                    │
│                                                    │
│              Main Content (full width)             │
│                                                    │
│                                                    │
└────────────────────────────────────────────────────┘
```

**Left panel open:**
```
┌──────────────────────┬─────────────────────────────┐
│ 📋 Navigation     ◀  │                             │
├──────────────────────┤                             │
│ • Dashboard          │   Main Content              │
│ • Projects           │   (flows to accommodate)    │
│ • Settings           │                             │
│                      │                             │
└──────────────────────┴─────────────────────────────┘
        280px                   flexible
```

**Left + Right panels open:**
```
┌──────────────┬──────────────────┬─────────────────┐
│📋 Nav     ◀  │                  │  ⚙️ Tools    ▶  │
├──────────────┤                  ├─────────────────┤
│• Dashboard   │  Main Content    │ Quick Actions   │
│• Projects    │  (flows between) │ • New Project   │
│• Settings    │                  │ • Import        │
└──────────────┴──────────────────┴─────────────────┘
     280px          flexible            280px
```

**Top panel open:**
```
┌────────────────────────────────────────────────────┐
│ 🔍 Filters                                      ▲  │
├────────────────────────────────────────────────────┤
│ Search: [          ]  Category: [All     ▼]        │
├────────────────────────────────────────────────────┤
│                                                    │
│              Main Content                          │
│              (flows down)                          │
│                                                    │
└────────────────────────────────────────────────────┘
```

**All four panels open:**
```
┌────────────────────────────────────────────────────┐
│ 🔍 Filters                                      ▲  │
├──────────────┬──────────────────┬─────────────────┤
│📋 Nav     ◀  │                  │  ⚙️ Tools    ▶  │
├──────────────┤                  ├─────────────────┤
│• Dashboard   │  Main Content    │ Quick Actions   │
│• Projects    │  (flows in all   │ • New Project   │
│• Settings    │   directions)    │ • Import        │
├──────────────┴──────────────────┴─────────────────┤
│ 💻 Console                                      ▲  │
├────────────────────────────────────────────────────┤
│ > output here...                                   │
└────────────────────────────────────────────────────┘
```

**User can work with any combination open:**
- Just left panel (browsing nav)
- Left + top (browsing + filtering)
- Left + right (nav + tools)
- All panels (maximum info density)

### Left Panel States

**Expanded:**
```
┌──────────────────────┬─────────────────────────────┐
│ 📋 Navigation     ◀  │                             │
├──────────────────────┤                             │
│ • Dashboard          │      Main Content           │
│ • Projects           │                             │
│ • Settings           │                             │
│                      │                             │
└──────────────────────┴─────────────────────────────┘
```

**Collapsed:**
```
┌──┬──────────────────────────────────────────────────┐
│📋│                                                  │
├──┤                                                  │
│  │             Main Content                         │
│◀ │             (more space)                         │
│  │                                                  │
└──┴──────────────────────────────────────────────────┘
```

### Top Panel States

**Expanded:**
```
┌────────────────────────────────────────────────────┐
│ 🔍 Filters                                      ▲  │
├────────────────────────────────────────────────────┤
│ Search: [          ]  Category: [All     ▼]        │
│ Date Range: [From] [To]                            │
├────────────────────────────────────────────────────┤
│                                                    │
│              Main Content                          │
│                                                    │
└────────────────────────────────────────────────────┘
```

**Collapsed:**
```
┌────────────────────────────────────────────────────┐
│ 🔍 Filters                                      ▼  │
├────────────────────────────────────────────────────┤
│                                                    │
│              Main Content                          │
│              (more space)                          │
│                                                    │
└────────────────────────────────────────────────────┘
```

---

## Customization via CSS Variables

**Toggle panels add only 4 new tokens.** Everything else uses existing Slim-Pickins tokens.

```css
/* New tokens (minimal additions to slim-pickins-tokens.css) */
:root {
  --panel-width: 280px;           /* Expanded width for left/right */
  --panel-height: 200px;          /* Expanded height for top/bottom */
  --panel-collapsed: 2.5rem;      /* 40px - collapsed size (all directions) */
  --panel-z: 100;                 /* Base z-index for layering */
}

/* Everything else reuses existing tokens: */
/* - Spacing: --sp-*, --pad-*, --gap-* */
/* - Colors: --paper-*, --ink-*, --border-*, --accent-* */
/* - Typography: --fs-*, --fw-*, --lh-* */
/* - Effects: --shadow-*, --radius-*, --focus-* */
```

**To customize panel sizes:**

```css
/* In your app.css or via <style> tag */
:root {
  --panel-width: 320px;           /* Wider sidebar */
  --panel-height: 240px;          /* Taller top/bottom */
  --panel-collapsed: 3rem;        /* 48px - more generous collapsed */
}

/* Or per-panel via inline styles */
.toggle-panel-left {
  --panel-width: 360px;           /* This panel only */
}
```

**Benefits of token integration:**
- No redundant color or spacing definitions
- Automatic dark mode support (if tokens support it)
- Consistent with rest of framework
- Easy to maintain and extend
- Print styles work automatically
- Accessibility features inherited

---

## Accessibility

### Keyboard Support
- **Space/Enter** on header → toggle panel
- **Tab** → navigate to toggle button
- **Escape** → close panel (optional)

### Screen Reader Support
- `role="button"` on header
- `aria-expanded` state
- `aria-controls` linking header to content
- `aria-label` for icon-only collapsed state

### ARIA Attributes
```html
<header class="panel-header"
        role="button"
        tabindex="0"
        aria-expanded="true"
        aria-controls="panel-content-id"
        aria-label="Toggle navigation panel">
```

---

## Benefits

### 1. **Unified System**
- One base helper (`togglepanel`)
- Consistent behavior across all positions
- Easy to understand and extend

### 2. **CSS-First**
- Smooth animations via CSS
- No JavaScript layout calculations
- Better performance
- Progressive enhancement

### 3. **Context-Aware**
- Fixed in layout.slim
- Scrollable in content templates
- Adapts to container

### 4. **Minimal JS**
- Only for toggle state
- LocalStorage persistence
- ARIA updates
- ~30 lines of code

### 5. **Responsive by Default**
- Works on mobile
- Touch-friendly
- Adapts to screen size
- Can be customized per breakpoint

### 6. **Flexible Layouts**
- Multiple panels can be open simultaneously
- Content flows naturally to accommodate
- Users control their workspace
- Smooth transitions between states

---

## Summary

```slim
/ Base helper with explicit position
togglepanel 'Title', position: :left

/ Convenience aliases (preferred)
toggleleft 'Navigation'
toggleright 'Tools'
toggletop 'Filters'
togglebottom 'Console'

/ In layout.slim → fixed position
/ In other views → scrolls with container

/ Click header → toggles open/closed
/ Horizontal (top/bottom) → shows icon + label when collapsed
/ Vertical (left/right) → shows icon only when collapsed

/ CSS handles:
/ - Positioning and sizing
/ - Animations
/ - Collapsed state display

/ JS handles:
/ - Toggle state
/ - LocalStorage persistence
/ - ARIA updates
```

**Simple. Elegant. Joyful.** 🍞✨
