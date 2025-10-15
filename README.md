# Slim-Pickins 🍞

> **Expression over specification. Minimalism over complexity. Joy over ceremony.**

An ultra-lightweight UI framework for building web applications with Ruby, Sinatra, Slim templates, StimulusJS, and modern CSS.

## Philosophy

Slim-Pickins believes templates should express **what you want**, not **how to build it**. We hide HTML and JavaScript implementation details behind elegant Ruby helpers and provide a Tufte-inspired CSS foundation, letting you write code that reads like your intentions.

**The best JavaScript is the least JavaScript.**  
**The best CSS respects Tufte's data-ink ratio.**

## Features

- ✨ **Clean Templates** - Express intent, not implementation
- 🎯 **Ruby Helpers** - Component-based without the framework bloat
- 🎨 **Tufte-Inspired CSS** - Data-forward design with semantic tokens
- 🔌 **Slim Filters** - Custom DSLs for common patterns
- ⚡ **StimulusJS Integration** - Minimal JavaScript, maximum interaction
- 📊 **Data Visualization Primitives** - Tables, sparklines, small multiples
- 🖨️ **Print-First** - Reports and documents print beautifully by default
- 📦 **Zero Build Step** - Edit, refresh, done
- 🍞 **Be as good as bread** - Simple ingredients, thoughtfully mixed

## Installation

Add to your Gemfile:

```ruby
gem 'slim-pickins', '~> 0.1'
```

Or install directly:

```bash
gem install slim-pickins
```

## Quick Start

### Ruby/Sinatra Setup

```ruby
# app.rb
require 'sinatra/base'
require 'slim-pickins'

class App < Sinatra::Base
  register SlimPickins
  
  get '/' do
    @items = Item.all
    slim :index
  end
end
```

### Using the CSS Framework

Slim-Pickins includes a complete CSS framework with three options:

#### Option 1: Complete Bundle (Recommended)

```html
<!-- In your layout -->
<link rel="stylesheet" href="/assets/stylesheets/slim-pickins.css">
```

Includes: tokens + base semantic HTML styling + utility classes

#### Option 2: Modular Import

```html
<!-- Import only what you need -->
<link rel="stylesheet" href="/assets/stylesheets/slim-pickins-tokens.css">
<link rel="stylesheet" href="/assets/stylesheets/slim-pickins-base.css">
<!-- Skip utilities if you don't need them -->
```

#### Option 3: Custom Tokens

```html
<!-- Override tokens, then import base -->
<link rel="stylesheet" href="/assets/stylesheets/slim-pickins-tokens.css">
<link rel="stylesheet" href="/css/my-custom-tokens.css">
<link rel="stylesheet" href="/assets/stylesheets/slim-pickins-base.css">
```

### Template Example

```slim
/ views/index.slim
h1 My Items

= modal id: "new-item", trigger: "New Item" do
  h2 Create Item
  = simple_form item_path do
    = field :title, required: true
    = field :description, type: :textarea
    = submit

= searchable items_path

.stack
  - @items.each do |item|
    = card item.title, class: "data-card" do
      p.muted = item.description
      .cluster.cluster-between
        span.small = item.created_at.strftime("%b %d")
        .cluster
          = action_button "Edit", action: "click->edit#show"
          = action_button "Delete", action: "click->delete#confirm", class: "btn-danger"
```

## CSS Token System

Slim-Pickins uses semantic, Ruby-inspired naming for CSS variables:

```css
/* Colors */
--ink-900      /* Primary text */
--paper-0      /* Primary background */
--accent-600   /* Links, primary actions */

/* Spacing */
--sp-3         /* 8px - base rhythm */
--sp-5         /* 16px - standard gap */
--gap-stack    /* Vertical rhythm */
--gap-cluster  /* Horizontal spacing */

/* Typography */
--fs-16        /* Base font size */
--prose-width  /* 75ch - optimal line length */
```

[See complete token reference](assets/stylesheets/slim-pickins-tokens.css)

## Utility Classes

```html
<!-- Layout -->
<div class="stack">...</div>           <!-- Vertical rhythm -->
<div class="cluster">...</div>         <!-- Horizontal wrap -->
<main class="center prose">...</main>  <!-- Centered, readable width -->

<!-- Components -->
<article class="card">...</article>
<button class="btn btn-secondary">...</button>
<span class="badge badge-primary">...</span>

<!-- Typography -->
<p class="muted small">Helper text</p>
<td class="numeric">1,234.56</td>
```

## Data Visualization

Slim-Pickins includes primitives for Tufte-inspired data presentation:

```slim
/ Tables with proper alignment
table.data-table
  thead
    tr
      th Scenario
      th.numeric Taxes (USD)
      th.numeric Net Worth
  tbody
    tr
      td A (fill bracket)
      td.numeric 124,500
      td.numeric 1,240,000

/ Inline sparklines (SVG)
td.numeric
  | 1.24M
  svg.sparkline(width="80" height="16")
    polyline(points="0,12 20,10 40,8 60,6 80,4")
```

## Philosophy & Design Principles

Read our complete [PHILOSOPHY.md](PHILOSOPHY.md) for:

- Expression over specification
- Tufte's data-ink ratio applied to web design
- Token-driven customization
- Print-first thinking
- Accessibility as table stakes

## Documentation

- [Getting Started](docs/getting_started.md)
- [Helpers Reference](docs/helpers_reference.md)
- [CSS Token Reference](assets/stylesheets/slim-pickins-tokens.css)
- [Philosophy](PHILOSOPHY.md)

## Example App

See the `example_app/` directory for a complete working application demonstrating all features:

```bash
cd example_app
bundle install
rackup
```

Visit http://localhost:9292

## Requirements

- Ruby 2.7+
- Sinatra 3.0+
- Slim 5.0+

## Contributing

Contributions welcome! Please maintain the spirit of simplicity and joy.

1. Fork it
2. Create your feature branch (`git checkout -b my-feature`)
3. Write tests
4. Commit your changes (`git commit -am 'Add feature'`)
5. Push to the branch (`git push origin my-feature`)
6. Create a Pull Request

## License

MIT License - see [LICENSE](LICENSE) file

## Credits

Inspired by:
- Edward Tufte's principles of information design
- Ruby and Sinatra communities' commitment to developer happiness
- The classless CSS movement (Pico, Sakura, Water.css)
- The principle of least astonishment (POLA)

**Built with joy. Maintained with care. Be as good as bread.** 🍞
