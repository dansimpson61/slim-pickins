# Slim-Pickins 🍞

> **Expression over specification. Minimalism over complexity. Joy over ceremony.**

An ultra-lightweight UI framework for building web applications with Ruby, Sinatra, Slim templates, StimulusJS, and modern CSS.

## Philosophy

Slim-Pickins believes templates should express **what you want**, not **how to build it**. We hide HTML and JavaScript implementation details behind elegant Ruby helpers and Slim filters, letting you write code that reads like your intentions.

**The best JavaScript is the least JavaScript.**

## Features

- ✨ **Clean Templates** - Express intent, not implementation
- 🎯 **Ruby Helpers** - Component-based without the framework bloat
- 🔌 **Slim Filters** - Custom DSLs for common patterns
- ⚡ **StimulusJS Integration** - Minimal JavaScript, maximum interaction
- 🎨 **Modern CSS** - Custom properties, logical layouts
- 📦 **Zero Build Step** - Edit, refresh, done
- 🍞 **As Good As Bread** - Simple ingredients, thoughtfully mixed

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

```slim
/ views/index.slim
h1 My Items

= modal id: "new-item" do
  h2 Create Item
  = simple_form item_path do
    = field :title
    = field :description, type: :textarea
    = submit

= searchable items_path

= sortable_list @items do |item|
  = card item.title do
    p = item.description
    = item_actions item
```

## Documentation

- [Getting Started](docs/getting_started.md)
- [Helpers Reference](docs/helpers_reference.md)
- [Philosophy](PHILOSOPHY.md)

## Example App

See the `example_app/` directory for a complete working application demonstrating all features.

```bash
cd example_app
bundle install
rackup
```

Visit http://localhost:9292

## Requirements

- Ruby 2.7+
- Sinatra 2.0+
- Slim 4.0+

## Contributing

Contributions welcome! Please maintain the spirit of simplicity and joy.

1. Fork it
2. Create your feature branch (`git checkout -b my-feature`)
3. Write tests
4. Commit your changes (`git commit -am 'Add feature'`)
5. Push to the branch (`git push origin my-feature`)
6. Create a Pull Request

## License

MIT License - see LICENSE file

## Credits

Inspired by the Ruby and Sinatra communities' commitment to developer happiness.

**Built with joy. Maintained with care. As good as bread.** 🍞
