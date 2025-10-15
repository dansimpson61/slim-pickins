# Slim-Pickins Reactive Demo 🍞

This demo shows reactive form patterns in action.

## Running the Demo

```bash
cd demo_app
bundle exec rackup -p 4567
```

Then open your browser to:
- **http://localhost:4567** - Interactive calculator
- **http://localhost:4567/examples** - Code examples

## What You'll See

1. **Compound Interest Calculator** - Type in any field and watch results update automatically
2. **Clean Slim Templates** - See how expressive the DSL is
3. **Minimal JavaScript** - Just one Stimulus controller does it all
4. **Server-Side Logic** - All calculations happen in Ruby

## The Joy

- No explicit submit button needed
- Debounced updates (300ms after typing stops)
- HTML-over-the-wire (server renders results)
- Clean, readable templates
- Progressive enhancement

**Be as good as bread.** 🍞
