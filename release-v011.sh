#!/bin/bash
# Release slim-pickins v0.1.1
# Run from project root: bash release-v0.1.1.sh

set -e

VERSION="0.1.1"
PREV_VERSION="0.1.0"

clear
echo "════════════════════════════════════════"
echo "🍞 slim-pickins Release v${VERSION}"
echo "════════════════════════════════════════"
echo ""
echo "This script will:"
echo "  1. Update version to ${VERSION}"
echo "  2. Create CHANGELOG.md"
echo "  3. Stage all changes"
echo "  4. Commit with release message"
echo "  5. Tag release"
echo "  6. Show what will be pushed"
echo ""
read -p "Continue? (y/n) " -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 1
fi

# Step 1: Update version
echo "Step 1/6: Updating version to ${VERSION}..."
cat > lib/slim_pickins/version.rb << EOF
# frozen_string_literal: true

module SlimPickins
  VERSION = '${VERSION}'
end
EOF
echo "  ✅ lib/slim_pickins/version.rb updated"
echo ""

# Step 2: Create CHANGELOG
echo "Step 2/6: Creating CHANGELOG.md..."
cat > CHANGELOG.md << 'EOF'
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
EOF
echo "  ✅ CHANGELOG.md created"
echo ""

# Step 3: Show what will be committed
echo "Step 3/6: Checking git status..."
echo ""
git status --short
echo ""

# Step 4: Stage all changes
echo "Step 4/6: Staging changes..."
git add -A
echo "  ✅ All changes staged"
echo ""

# Step 5: Commit
echo "Step 5/6: Creating commit..."
git commit -m "Release v${VERSION}: Complete CSS framework with asset serving

## Added
- Complete CSS framework (tokens, base, utilities)
- AssetServer module for gem asset distribution
- Dark mode support
- Print-first styling
- Data visualization primitives

## Fixed
- Asset path resolution
- MIME type handling for CSS files

As good as bread. 🍞"

echo "  ✅ Commit created"
echo ""

# Step 6: Create tag
echo "Step 6/6: Creating git tag v${VERSION}..."
git tag -a "v${VERSION}" -m "slim-pickins v${VERSION}

Complete CSS framework with Tufte-inspired design.
AssetServer for gem distribution.
As good as bread. 🍞"

echo "  ✅ Tag created"
echo ""

# Summary
echo "════════════════════════════════════════"
echo "✅ Release v${VERSION} Ready!"
echo "════════════════════════════════════════"
echo ""
echo "Commit created with changes:"
git log -1 --stat
echo ""
echo "Tag created:"
git tag -l -n3 "v${VERSION}"
echo ""
echo "════════════════════════════════════════"
echo "📤 PUSH TO REMOTE"
echo "════════════════════════════════════════"
echo ""
echo "To push this release, run:"
echo ""
echo "  git push origin main"
echo "  git push origin v${VERSION}"
echo ""
echo "Or push everything at once:"
echo "  git push origin main --tags"
echo ""
echo "════════════════════════════════════════"
echo "📦 BUILD & PUBLISH GEM (Optional)"
echo "════════════════════════════════════════"
echo ""
echo "To build and publish the gem:"
echo ""
echo "  gem build slim-pickins.gemspec"
echo "  gem push slim-pickins-${VERSION}.gem"
echo ""
echo "Or install locally:"
echo "  gem install ./slim-pickins-${VERSION}.gem"
echo ""
echo "🍞 As good as bread!"
