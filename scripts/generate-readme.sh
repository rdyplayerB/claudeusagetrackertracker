#!/bin/bash
set -e

# Generate README.md from trackers.json

COUNT=$(jq '.meta.total_count' trackers.json)

cat > README.md << 'HEADER'
# Claude Tracker Tracker

**Tracking the trackers.**

Everyone's building Claude usage trackers. This repo tracks them all.

HEADER

echo "![Trackers Tracked](https://img.shields.io/badge/trackers_tracked-${COUNT}-blue)" >> README.md

cat >> README.md << 'MIDDLE'

## The Trackers

| Name | Stars | Type | Description |
|------|-------|------|-------------|
MIDDLE

# Generate table rows from JSON
jq -r '.trackers[] | "| [\(.name)](\(.url)) | \(.stars) | \(.type) | \(.description | .[0:80]) |"' trackers.json >> README.md

cat >> README.md << 'FOOTER'

## Types

- **macos-app** - Native macOS menu bar applications
- **extension** - Browser extensions
- **dashboard** - Web-based dashboards
- **cli** - Command-line tools
- **tui** - Terminal UI applications
- **task-tracker** - Task/session management tools
- **mirror** - Source code mirrors with tracking
- **unknown** - Newly discovered, not yet categorized

## Add a Tracker

Found a tracker we missed? [Open an issue](../../issues/new) or submit a PR adding it to `trackers.json`.

## How This Works

A GitHub Action runs daily searching for new Claude usage trackers. When it finds one, it opens a PR. Merge = tracked.

---

*Yes, this is a tracker that tracks trackers. We are aware of the irony.*
FOOTER

echo "README.md regenerated with $COUNT trackers"
