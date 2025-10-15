#!/bin/bash
# Verify release is ready
# Run from project root: bash verify-release.sh

set -e

echo "🍞 Verifying slim-pickins release readiness..."
echo ""

all_good=true

# Check 1: All CSS files exist and have content
echo "✓ Checking CSS files..."
css_files=(
  "assets/stylesheets/slim-pickins-tokens.css"
  "assets/stylesheets/slim-pickins-base.css"
  "assets/stylesheets/slim-pickins-utils.css"
  "assets/stylesheets/slim-pickins.css"
)

for file in "${css_files[@]}"; do
  if [ -f "$file" ]; then
    size=$(wc -c < "$file")
    if [ "$size" -gt 1000 ]; then
      echo "  ✅ $file ($(($size / 1024))KB)"
    else
      echo "  ⚠️  $file (only ${size}B - might be incomplete)"
      all_good=false
    fi
  else
    echo "  ❌ $file (missing)"
    all_good=false
  fi
done
echo ""

# Check 2: Core Ruby files
echo "✓ Checking Ruby files..."
ruby_files=(
  "lib/slim_pickins.rb"
  "lib/slim_pickins/version.rb"
  "lib/slim_pickins/helpers.rb"
  "lib/slim_pickins/asset_server.rb"
  "lib/helpers/component_helpers.rb"
  "lib/helpers/pattern_helpers.rb"
  "lib/helpers/form_helpers.rb"
  "lib/helpers/stimulus_helpers.rb"
)

for file in "${ruby_files[@]}"; do
  if [ -f "$file" ]; then
    echo "  ✅ $file"
  else
    echo "  ❌ $file (missing)"
    all_good=false
  fi
done
echo ""

# Check 3: Documentation
echo "✓ Checking documentation..."
docs=(
  "README.md"
  "PHILOSOPHY.md"
  "LICENSE"
  "CHANGELOG.md"
)

for doc in "${docs[@]}"; do
  if [ -f "$doc" ]; then
    echo "  ✅ $doc"
  else
    echo "  ⚠️  $doc (missing - recommended)"
  fi
done
echo ""

# Check 4: Tests pass
echo "✓ Running tests..."
if bundle exec rake test > /dev/null 2>&1; then
  echo "  ✅ All tests pass"
else
  echo "  ⚠️  Some tests failing (check with: rake test)"
fi
echo ""

# Check 5: Example app works
echo "✓ Checking example app..."
if [ -f "example_app/app.rb" ] && [ -f "example_app/views/layout.slim" ]; then
  if grep -q 'href="/slim-pickins/assets/stylesheets/' example_app/views/layout.slim; then
    echo "  ✅ Example app configured correctly"
  else
    echo "  ⚠️  Example app may not use gem assets"
  fi
else
  echo "  ❌ Example app incomplete"
  all_good=false
fi
echo ""

# Check 6: Gemspec includes assets
echo "✓ Checking gemspec..."
if grep -q "assets/\*\*/\*" slim-pickins.gemspec; then
  echo "  ✅ Gemspec includes assets"
else
  echo "  ❌ Gemspec doesn't include assets"
  all_good=false
fi
echo ""

# Check 7: Git status
echo "✓ Checking git status..."
if [[ -z $(git status -s) ]]; then
  echo "  ✅ Working tree clean"
else
  echo "  ⚠️  Uncommitted changes:"
  git status -s | head -10
  echo ""
fi

# Summary
echo "════════════════════════════════════════"
if [ "$all_good" = true ]; then
  echo "✅ READY TO RELEASE!"
  echo "════════════════════════════════════════"
  echo ""
  echo "Next steps:"
  echo "  1. bash release-v0.1.1.sh    (create commit & tag)"
  echo "  2. bash push-release.sh       (push to remote)"
  echo ""
else
  echo "⚠️  NOT READY - Fix issues above"
  echo "════════════════════════════════════════"
fi

echo "🍞 As good as bread!"
