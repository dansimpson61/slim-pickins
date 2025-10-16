git commit -F - << 'EOF'
feat: Add reactive forms with calculator DSL and showcase CSS framework

## Reactive Form Patterns

- Add ReactiveFormHelpers for automatic form updates without submit
- Add CalculatorDSLHelpers with domain-specific field types
- Create reactive-form Stimulus controller with debouncing
- Implement HTML-over-the-wire pattern for server-side calculations
- Support model binding and automatic JSON serialization

New helpers:
- `reactive_form` - Auto-updating forms with debounced input
- `reactive_field` - Individual reactive input fields
- `money_field` - Currency input with $ prefix
- `percent_field` - Percentage input with % suffix
- `year_field` - Year input with sensible constraints
- `results_table` - Formatted results display

## Test Coverage

- Add comprehensive test suite for reactive helpers
- Add tests for calculator DSL helpers
- Fix ComponentHelpers to handle nil titles gracefully
- Fix semantic HTML (<article> instead of <div> for cards)
- Fix integer formatting in results_table
- Fix Slim syntax issues with multi-line hashes
- All 98 tests passing with 490+ assertions

## Demo App Enhancements

- Transform demo to showcase slim-pickins CSS framework
- Register AssetServer to serve CSS from gem
- Rewrite all views with semantic HTML + design tokens
- Add comprehensive examples page demonstrating framework
- Add extensive console and server logging for debugging
- Remove custom CSS (framework provides everything needed)
- Fix VERSION constant duplication warning
- Fix button navigation and endpoint URLs

## Documentation

- Create GETTING_STARTED.md with complete setup guide
- Create TROUBLESHOOTING.md for debugging reactive forms
- Create CSS_FRAMEWORK.md documenting framework usage
- Create SLIM_SYNTAX_GUIDE.md for common patterns
- Add inline documentation for all new helpers

## Philosophy Maintained

- Server-first: All calculations in Ruby
- Minimal JavaScript: Single 80-line Stimulus controller
- HTML-over-the-wire: Server renders results
- Progressive enhancement: Forms work without JS
- Expression over specification: Clean, intent-revealing templates
- Tufte-inspired design: Data-ink ratio respected throughout
- No build step: ES6 modules via CDN

The demo app now exemplifies joyful, data-forward web development
with reactive forms, beautiful typography, and semantic HTML.

As good as bread. 🍞
EOF
