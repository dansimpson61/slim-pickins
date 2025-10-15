# Changelog

All notable changes to slim-pickins will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

**As good as bread.** 🍞
