#!/bin/bash
# Push release to remote
# Run from project root: bash push-release.sh

set -e

echo "🍞 Pushing slim-pickins release..."
echo ""

# Check if we're on the right branch
BRANCH=$(git branch --show-current)
echo "Current branch: $BRANCH"
echo ""

# Check for uncommitted changes
if [[ -n $(git status -s) ]]; then
  echo "⚠️  Warning: You have uncommitted changes:"
  git status -s
  echo ""
  read -p "Continue anyway? (y/n) " -r
  echo ""
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
  fi
fi

# Show what will be pushed
echo "Commits to push:"
git log origin/$BRANCH..$BRANCH --oneline 2>/dev/null || git log --oneline -5
echo ""

echo "Tags to push:"
git tag -l | tail -5
echo ""

# Confirm
read -p "Push to origin/$BRANCH with tags? (y/n) " -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 1
fi

# Push
echo "Pushing commits..."
git push origin $BRANCH

echo ""
echo "Pushing tags..."
git push origin --tags

echo ""
echo "════════════════════════════════════════"
echo "✅ Release Pushed!"
echo "════════════════════════════════════════"
echo ""
echo "View on GitHub:"
echo "  https://github.com/YOUR-USERNAME/slim-pickins"
echo ""
echo "🍞 As good as bread!"
