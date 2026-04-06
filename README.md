# Claude Tracker Tracker

**Tracking the trackers.**

Everyone's building Claude usage trackers. This repo tracks them all.

![Trackers Tracked](https://img.shields.io/badge/trackers_tracked-15-blue)

## The Trackers

| Name | Stars | Type | Description |
|------|-------|------|-------------|
| [Claude-Usage-Tracker](https://github.com/hamed-elfayome/Claude-Usage-Tracker) | 1933 | macos-app | Native macOS menu bar app for tracking Claude AI usage limits in real-time. Buil |
| [opensync](https://github.com/waynesutton/opensync) | 349 | dashboard | Cloud-synced dashboards for OpenCode and Claude Code. Track sessions, search wit |
| [Claude-Usage-Extension](https://github.com/lugia19/Claude-Usage-Extension) | 247 | extension | Claude Usage Tracker browser extension |
| [ClaudeUsageTracker](https://github.com/masorange/ClaudeUsageTracker) | 109 | macos-app | Track your Claude Code API usage from your macOS menu bar with accurate cost cal |
| [claude-code-source-all-in-one](https://github.com/wuwangzhang1216/claude-code-source-all-in-one) | 55 | mirror | Always up-to-date open-source mirror of Claude Code, tracking the official relea |
| [claude-usage-tracker](https://github.com/658jjh/claude-usage-tracker) | 36 | dashboard | Track and visualize Claude AI usage costs across all local tools — OpenClaw, Cla |
| [claude-usage-tracker-for-mac](https://github.com/penicillin0/claude-usage-tracker-for-mac) | 24 | macos-app | Happy Hacking With Claude!!! |
| [master-plan](https://github.com/endlessblink/master-plan) | 22 | task-tracker | AI-native task management for Claude Code. Track tasks in MASTER_PLAN.md — pick, |
| [claude-code-tracker](https://github.com/m-shirt/claude-code-tracker) | 20 | dashboard | Self-hosted multi-user analytics dashboard for Claude Code — track sessions, con |
| [Oh-My-Claude](https://github.com/hey-pals/Oh-My-Claude) | 5 | dashboard | Real-time monitoring dashboard for Claude Code — track tokens, agents, teams, co |
| [claude-token-tracker](https://github.com/pepperonas/claude-token-tracker) | 4 | dashboard | Token usage dashboard for Claude Code — tracks costs, sessions, models, and tool |
| [claude-peek](https://github.com/teambrilliant/claude-peek) | 4 | macos-app | macOS notch status surface for Claude Code — track sessions, approve permissions |
| [ClaudeUsage](https://github.com/LouisVanh/ClaudeUsage) | 3 | cli | Lightweight Claude Usage Tracker |
| [claude-tracker](https://github.com/DSado88/claude-tracker) | 2 | tui | Multi-account Claude usage tracker TUI (Rust/ratatui) |
| [cctrack](https://github.com/haoagent/cctrack) | 2 | dashboard | Real-time cost & activity dashboard for Claude Code. Track every dollar, every t |

## The App

Yes, there's a menu bar app. Because of course there is.

**Download:** [ClaudeTrackerTracker.app](app/ClaudeTrackerTracker.app)

1. Download the app folder
2. Move `ClaudeTrackerTracker.app` to Applications
3. Open it (you may need to right-click → Open the first time)
4. See the tracker count in your menu bar

The app fetches live data from this repo. When new trackers are added, your count updates automatically.

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
