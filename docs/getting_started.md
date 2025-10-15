# Getting Started with Slim-Pickins

Welcome! Let's get you building beautiful web UIs with clean templates in 5 minutes.

## Installation

Add to your Gemfile:

```ruby
gem 'slim-pickins', '~> 0.1'
```

Or install directly:

```bash
gem install slim-pickins
```

## Setup with Sinatra

Create a basic Sinatra app:

```ruby
# app.rb
require 'sinatra/base'
require 'slim-pickins'

class App < Sinatra::Base
  register SlimPickins
  
  get '/' do
    @items = ["Clean templates", "No ceremony", "Pure joy"]
    slim :index
  end
end
```

Create your first template:

```slim
/ views/index.slim
h1 Welcome to Slim-Pickins

== card "My Items" do
  ul
    - @items.each do |item|
      li = item
```

Run it:

```bash
ruby app.rb
```

Visit `http://localhost:4567` and see your beautiful card!

## Key Concepts

### 1. Use `==` for Helpers

Slim-Pickins helpers return HTML. Use `==` (unescaped output):

```slim
/ Good ✓
== modal id: "test" do
  p Content

/ Bad ✗ (will show raw HTML)
= modal id: "test" do
  p Content
```

### 2. Helpers Take Blocks

Most helpers accept Ruby blocks for content:

```slim
== card "Title" do
  p Your content here
  p Multiple elements work great
```

### 3. Express Intent, Not Implementation

Before Slim-Pickins:
```slim
div data-controller="modal" data-modal-open-value="false"
  button data-action="click->modal#open" class="btn" Open
  div data-modal-target="backdrop" class="modal-backdrop hidden"
    / ... 20 more lines of ceremony
```

With Slim-Pickins:
```slim
== modal id: "my-modal", trigger: "Open" do
  h2 Simple!
```

That's the philosophy: **expression over specification**.

## Common Patterns

### Creating a Form

```slim
== simple_form "/items" do
  == field :title, required: true
  == field :description, type: :textarea
  == submit "Create Item"
```

### Adding a Modal

```slim
== modal id: "new-item", trigger: "New Item" do
  h2 Create Something
  == simple_form "/items" do
    == field :name
    == submit
```

### Search with Live Results

```slim
== searchable "/search", placeholder: "Find items..."
```

Your `/search` endpoint should return an HTML fragment.

### Navigation

```slim
nav
  == nav_link "Home", "/"
  == nav_link "About", "/about"
  == nav_link "Contact", "/contact"
```

Active page is highlighted automatically!

## Next Steps

- Explore the [Helpers Reference](helpers_reference.md) for all available helpers
- Check out the `example_app/` for a complete working application
- Visit the `sampler/` to see every helper in action
- Read [PHILOSOPHY.md](../PHILOSOPHY.md) to understand our approach

## Tips

1. **Start simple** - Use basic helpers first, add complexity only when needed
2. **Let Ruby do the work** - Helpers generate all the Stimulus data attributes
3. **Trust the defaults** - Most helpers work great with minimal configuration
4. **Check the sampler** - Visual examples are worth a thousand docs

## Troubleshooting

**"Raw HTML is showing in my templates"**

Use `==` instead of `=` for helper calls:
```slim
== card "Title" do    / Correct
= card "Title" do     / Wrong - will escape HTML
```

**"Helper not found"**

Make sure you registered Slim-Pickins in your app:
```ruby
class App < Sinatra::Base
  register SlimPickins  # Don't forget this!
end
```

**"Stimulus not working"**

Include Stimulus in your layout:
```slim
script type="module" src="https://cdn.jsdelivr.net/npm/@hotwired/stimulus@3.2.2/dist/stimulus.min.js"
script type="module" src="/js/app.js"
```

## Philosophy Reminder

Remember: Slim-Pickins is about **joy**. If something feels complex, there's probably a simpler way.

**Be as good as bread.** 🍞
