# Changelog

All notable changes to slim-pickins will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.2] - 2025-10-15

### Added - Reactive Form Patterns

- **ReactiveFormHelpers** - Automatic form updates without submit buttons
  - `reactive_form` - Creates forms that auto-update on input changes
  - `reactive_field` - Individual reactive input fields
  - `reactive_results` - Container for dynamically updated results
- **CalculatorDSLHelpers** - Domain-specific field types for financial apps
  - `money_field` - Currency input with $ prefix and validation
  - `percent_field` - Percentage input with % suffix (0-100 range)
  - `year_field` - Year input with sensible min/max constraints
  - `results_table` - Formatted results display with currency formatting
  - `result_row` - Individual table row helper for manual table building
- **Stimulus reactive-form controller** - 80-line controller for reactive updates
  - Debounced input handling (300ms default)
  - Automatic JSON serialization
  - HTML-over-the-wire pattern
  - Extensive console logging for debugging
- **HTML-over-the-wire pattern** - Server-side rendering with client updates
  - POST JSON to server endpoint
  - Server calculates and renders HTML fragment
  - Client replaces DOM with updated results
  - Zero client-side state management

### Added - Demo Application

- **Comprehensive demo app** showcasing reactive forms
  - Interactive compound interest calculator
  - Live updates as you type (debounced)
  - Server-side calculations in Ruby
  - HTML fragment replacement
- **Examples page** demonstrating CSS framework features
  - Typography hierarchy showcase
  - Data table examples with projection data
  - Layout utilities (stack, cluster, grid)
  - Form elements with beautiful defaults
  - Design token color swatches
  - Framework philosophy explanation
- **AssetServer integration** in demo app
  - Serves CSS directly from gem
  - No custom CSS files needed
  - Exemplary use of framework base styles and tokens

### Added - Documentation

- **GETTING_STARTED.md** - Complete setup guide with examples
- **TROUBLESHOOTING.md** - Debugging guide for reactive forms
  - Browser console checks
  - Network request debugging
  - Common issues and solutions
  - Manual testing steps
- **CSS_FRAMEWORK.md** - Framework usage documentation
  - Loading options (gem, CDN, custom)
  - Base styles overview
  - Utility classes reference
  - Design tokens catalog
  - Dark mode documentation
  - Print styles guide
- **SLIM_SYNTAX_GUIDE.md** - Common patterns and gotchas
  - Hash syntax in Slim
  - Line continuation with backslash
  - Helper calling patterns
  - Common pitfalls and solutions

### Added - Tests

- **ReactiveFormHelpersTest** - 6 tests for reactive form generation
- **CalculatorDSLHelpersTest** - 5 tests for domain-specific helpers
- **Comprehensive test coverage** for all new helpers
- **Integration tests** for demo app functionality

### Changed

- **ComponentHelpers.card** now uses semantic `<article>` instead of `<div>`
  - Better accessibility and SEO
  - Follows HTML5 semantic best practices
- **Demo app completely rewritten** to showcase framework CSS
  - Semantic HTML throughout
  - Uses design tokens instead of custom values
  - Minimal utility classes for layout
  - Zero custom CSS files
- **Form helpers enhanced** for better reactive integration
  - Support for data attributes
  - Automatic Stimulus target registration
  - Clean HTML generation
- **Test helper updated** to support all new modules
  - MockRequest includes path_info
  - JSON parsing available
  - All helper modules included

### Fixed

- **ComponentHelpers** nil title handling - no longer crashes with nil title
- **ComponentHelpers** controller attribute handling - properly builds attrs string
- **ReactiveFormHelpers** data attributes - reactive_field generates correct Stimulus attrs
- **CalculatorDSLHelpers** integer formatting - results_table formats integers as currency
- **Slim syntax issues** in demo app - proper multi-line hash syntax with backslash
- **VERSION constant duplication** - conditional loading prevents warning
- **Button navigation** - uses regular links instead of action_button for page nav
- **Reactive form URL generation** - properly determines endpoint based on path
- **Semantic HTML** - card helper uses `<article>` element
- **Test failures** - all 98 tests now passing with 490+ assertions

### Philosophy Maintained

- ✅ **Server-first** - All calculations in Ruby, client just coordinates
- ✅ **Minimal JavaScript** - Single 80-line Stimulus controller
- ✅ **HTML-over-the-wire** - Server renders all UI
- ✅ **Progressive enhancement** - Forms work without JavaScript
- ✅ **Expression over specification** - Templates read like intent
- ✅ **Tufte's data-ink ratio** - Every pixel serves the content
- ✅ **No build step** - ES6 modules via CDN
- ✅ **Be as good as bread** - Simple, nourishing, fundamental

## [0.1.1] - 2025-01-XX

### Added

- Complete CSS framework with Tufte-inspired design tokens
- `slim-pickins-tokens.css` - Semantic token system with 130+ CSS variables
- `slim-pickins-base.css` - Beautiful default styling for semantic HTML
- `slim-pickins-utils.css` - Minimal utility classes for layout composition
- AssetServer module to serve CSS/JS from gem
- Automatic dark mode support via `prefers-color-scheme`
- Print-first styling for reports and documents
- Data visualization primitives (tables, sparklines, small multiples)

### Changed

- Gemspec now includes `assets/**/*.{css,js}` files
- Example app refactored to use gem-served CSS
- Updated README with CSS framework documentation

### Fixed

- AssetServer path calculation (was going up too many directories)
- MIME type handling for served CSS files
- Asset routing for proper gem distribution

## [0.1.0] - 2025-01-XX

### Added

- Initial release
- Ruby helper modules: ComponentHelpers, PatternHelpers, FormHelpers, StimulusHelpers
- Sinatra integration via `register SlimPickins`
- Slim template support
- StimulusJS integration patterns
- Example TODO application
- Test suite with Minitest
- Philosophy document (PHILOSOPHY.md)

### Philosophy

- Expression over specification
- Minimalism over complexity
- Joy over ceremony
- Tufte's restraint + Ruby's expressiveness
- The best JavaScript is the least JavaScript

---

**Be as good as bread.** 🍞
