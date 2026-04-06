#!/bin/bash
set -e

# Add a tracker manually
# Usage: ./scripts/add-tracker.sh owner/repo [type]

if [ -z "$1" ]; then
  echo "Usage: $0 owner/repo [type]"
  echo "Example: $0 someone/claude-tracker macos-app"
  exit 1
fi

REPO="$1"
TYPE="${2:-unknown}"
TODAY=$(date +%Y-%m-%d)

# Fetch repo info from GitHub
echo "Fetching info for $REPO..."
INFO=$(gh api "repos/$REPO" --jq '{name: .name, url: .html_url, description: .description, stars: .stargazers_count}')

if [ -z "$INFO" ]; then
  echo "Error: Could not fetch repo info"
  exit 1
fi

# Check if already tracked
if jq -e ".trackers[] | select(.repo == \"$REPO\")" trackers.json > /dev/null 2>&1; then
  echo "Error: $REPO is already tracked"
  exit 1
fi

# Add to trackers.json
jq --argjson info "$INFO" --arg repo "$REPO" --arg type "$TYPE" --arg today "$TODAY" '
  .trackers += [{
    name: $info.name,
    repo: $repo,
    url: $info.url,
    description: ($info.description // ""),
    stars: $info.stars,
    type: $type,
    discovered: $today
  }] |
  .trackers |= sort_by(-.stars) |
  .meta.last_updated = $today |
  .meta.total_count = (.trackers | length)
' trackers.json > /tmp/updated.json
mv /tmp/updated.json trackers.json

echo "Added $REPO as $TYPE"
echo "Regenerating README..."
./scripts/generate-readme.sh
