# Slim-Pickins Documentation

> **Templates that read like poetry. Code that brings joy.**

---

## 🎯 Start Here

### New to Slim-Pickins?
1. **[The Slim-Pickins Way](THE_SLIM_PICKINS_WAY.md)** ⭐ START HERE
   - Philosophy, principles, and quick start
   - What works now vs what's coming
   - Golden rules and anti-patterns

2. **[Getting Started](getting_started.md)**
   - Installation and setup
   - Basic concepts
   - Your first template

3. **[Beautiful Templates](BEAUTIFUL_TEMPLATES.md)**
   - Real-world examples
   - Complete applications
   - Best practices in action

---

## 🧠 Core Concepts

### Understanding the Framework

**[Helpers vs Filters](HELPERS_VS_FILTERS.md)**
- The division of labor
- When to use what
- Decision tree and patterns
- Anti-patterns to avoid

**[Helpers & Filters Vision](HELPERS_AND_FILTERS_VISION.md)**
- The complete vision
- What helpers enable
- What filters enable
- The beautiful synthesis

**[Current vs Future](CURRENT_VS_FUTURE.md)**
- What works TODAY (v0.1)
- What's coming soon
- Roadmap through v1.0
- Working examples now

**[Visual Integration Guide](VISUAL_INTEGRATION_GUIDE.md)** 🎨
- See how helpers and filters work together
- Visual flow diagrams
- Layer-by-layer breakdown
- Composition patterns

---

## 📚 Reference Documentation

### API References

**[Helpers Reference](helpers_reference.md)**
- Complete helper catalog
- Signatures and options
- Usage examples
- All current helpers documented

**[Slim Syntax Guide](SLIM_SYNTAX_GUIDE.md)**
- Passing hashes to helpers
- Line continuation
- Common pitfalls
- Best practices

### Design Guidance

**[AI Agent UI/UX](AI_Agent_UI-UX.md)**
- World-class UI/UX principles
- Edward Tufte sensibilities
- Design system guidelines
- Accessibility standards

**[UI/UX DSL Vision](slim-pickins UI-UX DSL vision.md)**
- Future vision (Level 3 DSL)
- Convention-based helpers
- Smart components
- Implementation strategy

---

## 💡 Examples & Patterns

**[Examples](examples.md)**
- CRUD applications
- User authentication
- Dashboards
- Admin panels
- Multi-step forms
- Real-time search

**[Beautiful Templates](BEAUTIFUL_TEMPLATES.md)**
- Dashboard layouts
- E-commerce pages
- Financial calculators
- User profiles
- Admin interfaces

---

## 📖 Documentation by Topic

### For Beginners
1. [Getting Started](getting_started.md)
2. [The Slim-Pickins Way](THE_SLIM_PICKINS_WAY.md)
3. [Examples](examples.md)
4. [Slim Syntax Guide](SLIM_SYNTAX_GUIDE.md)

### For Understanding
1. [Helpers vs Filters](HELPERS_VS_FILTERS.md)
2. [Helpers & Filters Vision](HELPERS_AND_FILTERS_VISION.md)
3. [Current vs Future](CURRENT_VS_FUTURE.md)

### For Reference
1. [Helpers Reference](helpers_reference.md)
2. [Slim Syntax Guide](SLIM_SYNTAX_GUIDE.md)
3. [Beautiful Templates](BEAUTIFUL_TEMPLATES.md)

### For Vision
1. [UI/UX DSL Vision](slim-pickins UI-UX DSL vision.md)
2. [AI Agent UI/UX](AI_Agent_UI-UX.md)
3. [Helpers & Filters Vision](HELPERS_AND_FILTERS_VISION.md)

---

## 🎨 The Philosophy

### Expression Over Specification
Templates express **intent**, not implementation.

```slim
/ You write this:
== modal id: "welcome" do
  p Hello!

/ Not this:
div data-controller="modal" data-modal-open-value="false"
  button data-action="click->modal#open" Open
  / ... 15 more lines of wiring
```

### Helpers for Structure, Filters for Data

**Helpers** create components:
```slim
== card "Title" do
== modal id: "x" do
== reactive_form model: @calc do
```

**Filters** format data:
```slim
currency:
  = @amount
percent:
  = @rate
time_ago:
  = @created_at
```

### Hide All Complexity

- ❌ No data attributes in templates
- ❌ No Stimulus wiring visible
- ❌ No JavaScript implementation exposed
- ✅ Clean, expressive syntax only

### Compose Naturally

```slim
== card "User" do
  == avatar @user
  h3 = @user.name
  == dropdown "Actions" do
    == menu_item "Edit", edit_path
```

---

## 🚀 Quick Start

### 1. Install
```ruby
# Gemfile
gem 'slim-pickins', '~> 0.1'
```

### 2. Setup Sinatra
```ruby
require 'slim-pickins'

class App < Sinatra::Base
  register SlimPickins
  
  get '/' do
    slim :index
  end
end
```

### 3. Include CSS
```html
<link rel="stylesheet" href="/assets/stylesheets/slim-pickins.css">
```

### 4. Write Templates
```slim
/ views/index.slim
h1 Welcome

== card "Getting Started" do
  p This is joyful!
  == action_button "Click Me", action: "click->demo#greet"
```

---

## 📦 What's Included

### Current Features (v0.1)

**Layout Helpers:**
- `card`, `section`, `panel`
- Layout utilities: `.stack`, `.cluster`, `.grid-2`

**Form Helpers:**
- `simple_form`
- `field`, `submit`
- `reactive_form` (auto-updating!)

**Domain-Specific:**
- `money_field`, `percent_field`, `year_field`
- `calculator_form`
- `results_table`

**Interactive:**
- `modal`, `dropdown`, `tabs`
- `searchable` (live search)
- `action_button`, `nav_link`

**CSS Framework:**
- Tufte-inspired design tokens
- Semantic base styles
- Utility classes
- Print-friendly

### Coming Soon

**v0.2 - Slim Filters:**
- `currency:`, `percent:`, `date:`
- `sparkline:`, `trend:`, `badge:`
- Inline data transformation

**v0.3 - Smart Components:**
- `data_table` with sorting/filtering
- Chart helpers
- Metric cards

**v0.4 - Convention-Based:**
- Field type inference
- Smart form builders
- Minimal configuration

---

## 🎯 Use Cases

### ✅ Perfect For:
- Server-rendered web apps
- Dashboards and admin panels
- E-commerce sites
- Financial calculators
- Data-heavy applications
- Rapid prototyping
- Internal tools

### ⚠️ Consider Alternatives If:
- You need a SPA framework (use React/Vue)
- You have complex client-side state (use a full framework)
- You don't use Ruby/Sinatra (framework is Ruby-specific)

---

## 🛠️ Development Workflow

### Creating New Features

1. **Read the vision docs** to understand patterns
2. **Check current capabilities** in reference docs
3. **Look at examples** for inspiration
4. **Use helpers consistently** - never write data attributes
5. **Format with Ruby** (until filters arrive)

### Best Practices

```slim
/ ✅ DO: Use helpers
== card "Title" do
  p Content

/ ❌ DON'T: Write data attributes
div data-controller="card"
  p Content

/ ✅ DO: Use Ruby for formatting (for now)
.price = number_to_currency(@amount)

/ ✅ DO: Build hashes for complex data
- data = { \
    "Label": @value \
  }
== results_table(data)

/ ✅ DO: Nest helpers naturally
== card do
  == dropdown "Menu" do
    == menu_item "Edit", path
```

---

## 📚 Additional Resources

### Philosophy
- **[PHILOSOPHY.md](../PHILOSOPHY.md)** - Core beliefs and anti-patterns
- **[Ode to Joy](Ode to Joy - Ruby and Sinatra.txt)** - The original inspiration

### Project Files
- **[README.md](../README.md)** - Main project README
- **[CHANGELOG.md](../CHANGELOG.md)** - Version history
- **[LICENSE](../LICENSE)** - MIT License

---

## 🤝 Contributing

Before contributing, please:
1. Read **[The Slim-Pickins Way](THE_SLIM_PICKINS_WAY.md)**
2. Review **[Helpers vs Filters](HELPERS_VS_FILTERS.md)**
3. Check **[Current vs Future](CURRENT_VS_FUTURE.md)** for roadmap
4. Look at **[Beautiful Templates](BEAUTIFUL_TEMPLATES.md)** for patterns

### Helper Guidelines:
- Hide all implementation details
- Accept blocks for content
- Provide smart defaults
- Compose naturally with other helpers

### Filter Guidelines (when we add them):
- Transform data, don't create structure
- Use readable names
- Ensure consistent output
- Avoid side effects

---

## 🍞 Be as good as bread

**Simple ingredients:**
- Ruby (the flour)
- Slim (the water)
- StimulusJS (the yeast)
- Modern CSS (the salt)

**Mixed with care:**
- Hide complexity
- Express intent
- Trust conventions
- Embrace composition

**The result:**
- Templates that read like poetry
- Code that brings joy
- Interfaces that delight

**Welcome to Slim-Pickins.** ✨

---

## 📖 Document Index

| Document | Purpose | Audience |
|----------|---------|----------|
| [THE_SLIM_PICKINS_WAY.md](THE_SLIM_PICKINS_WAY.md) | Complete overview & philosophy | Everyone - START HERE |
| [getting_started.md](getting_started.md) | Installation & first steps | Beginners |
| [HELPERS_VS_FILTERS.md](HELPERS_VS_FILTERS.md) | Core concept: division of labor | All developers |
| [HELPERS_AND_FILTERS_VISION.md](HELPERS_AND_FILTERS_VISION.md) | Complete vision & future | Understanding the framework |
| [CURRENT_VS_FUTURE.md](CURRENT_VS_FUTURE.md) | What works now vs coming soon | Planning development |
| [BEAUTIFUL_TEMPLATES.md](BEAUTIFUL_TEMPLATES.md) | Real-world examples | Learning patterns |
| [helpers_reference.md](helpers_reference.md) | API reference | Daily use |
| [SLIM_SYNTAX_GUIDE.md](SLIM_SYNTAX_GUIDE.md) | Slim-specific patterns | Solving problems |
| [examples.md](examples.md) | Code examples | Learning & reference |
| [AI_Agent_UI-UX.md](AI_Agent_UI-UX.md) | Design principles | UI/UX design |
| [slim-pickins UI-UX DSL vision.md](slim-pickins UI-UX DSL vision.md) | Future DSL vision | Long-term planning |

---

**Last updated:** October 16, 2025  
**Version:** 0.1.0  
**Status:** Core documentation complete, examples clarified ✅
