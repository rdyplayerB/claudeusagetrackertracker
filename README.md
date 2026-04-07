# Claude Usage Tracker Tracker

<p align="center">
  <img src="cutt-logo.png" alt="CUTT Logo" width="100">
  <br><br>
  <strong>Everyone's building Claude usage trackers. This repo tracks them.</strong>
  <br><br>
  <img src="https://img.shields.io/badge/trackers-23-orange" alt="Trackers">
  <img src="https://img.shields.io/badge/total_stars-2,429-yellow" alt="Stars">
</p>

<p align="center">
  <img src="cutt-screenshot.png?v=3" alt="CUTT App Screenshot" width="320">
</p>

## Leaderboard

| | Name | Type | Stars | Description |
|:---:|------|------|-------|-------------|
| 🥇 | [Claude-Usage-Tracker](https://github.com/hamed-elfayome/Claude-Usage-Tracker) | macOS | 1,935 | Native menu bar app for tracking Claude AI usage limits in real-time |
| 🥈 | [Claude-Usage-Extension](https://github.com/lugia19/Claude-Usage-Extension) | Extension | 247 | Claude Usage Tracker browser extension |
| 🥉 | [ClaudeUsageTracker](https://github.com/masorange/ClaudeUsageTracker) | macOS | 109 | Track Claude Code API usage from your menu bar |
| 4 | [claude-usage-tracker](https://github.com/658jjh/claude-usage-tracker) | Web | 36 | Track usage costs across Claude Code, Cursor, Windsurf, Cline, and more |
| 5 | [claude-usage-tracker-for-mac](https://github.com/penicillin0/claude-usage-tracker-for-mac) | macOS | 24 | Happy Hacking With Claude! |

<details>
<summary><strong>View all 23 trackers</strong></summary>

| # | Name | Type | Stars | Description |
|---|------|------|-------|-------------|
| 6 | [claude-code-tracker](https://github.com/m-shirt/claude-code-tracker) | Web | 21 | Self-hosted multi-user analytics dashboard for Claude Code |
| 7 | [Oh-My-Claude](https://github.com/hey-pals/Oh-My-Claude) | Web | 5 | Real-time monitoring dashboard for Claude Code |
| 8 | [claude-code-tracker](https://github.com/55onurisik/claude-code-tracker) | Web | 5 | Claude Code usage tracker |
| 9 | [ClaudeUsageTracker](https://github.com/SergioBanuls/ClaudeUsageTracker) | macOS | 5 | Track Claude Code API usage from your menu bar |
| 10 | [ClaudeUsageTracker](https://github.com/pratikbaid3/ClaudeUsageTracker) | macOS | 5 | Claude usage tracking app |
| 11 | [claude-token-tracker](https://github.com/pepperonas/claude-token-tracker) | Web | 4 | Token usage dashboard with real-time updates |
| 12 | [claude-peek](https://github.com/teambrilliant/claude-peek) | macOS | 4 | Notch status surface for Claude Code |
| 13 | [sygil](https://github.com/Mastersam07/sygil) | Web | 4 | Real-time analytics dashboard, zero config |
| 14 | [ClaudeUsage](https://github.com/LouisVanh/ClaudeUsage) | CLI | 3 | Lightweight Claude Usage Tracker |
| 15 | [claude-usage-tracker](https://github.com/cfranci/claude-usage-tracker) | macOS | 3 | Menu bar app showing usage limits and reset times |
| 16 | [claude-usage-tracker](https://github.com/haasonsaas/claude-usage-tracker) | CLI | 3 | Parse JSONL logs, calculate costs, rate limit warnings |
| 17 | [claude-code-tracker](https://github.com/kelsi-andrewss/claude-code-tracker) | Web | 3 | Claude Code usage tracker |
| 18 | [claude-code-usage-analytics](https://github.com/wangtae/claude-code-usage-analytics) | Web | 3 | Multi-device usage monitoring dashboard |
| 19 | [claude-tracker](https://github.com/DSado88/claude-tracker) | TUI | 2 | Multi-account tracker (Rust/ratatui) |
| 20 | [cctrack](https://github.com/haoagent/cctrack) | Web | 2 | Real-time cost & activity dashboard |
| 21 | [mcp-cost-tracker](https://github.com/IgniteStudiosLtd/mcp-cost-tracker) | MCP | 2 | Track session costs across all projects |
| 22 | [claude-code-telemetry-setup](https://github.com/OmriYaHoo/claude-code-telemetry-setup) | Web | 2 | One-command Grafana dashboard setup |
| 23 | [claude-usage-tracker](https://github.com/eli-manning/claude-usage-tracker) | CLI | 2 | Claude usage tracker |

</details>

## The App

A macOS menu bar app that shows the live tracker count, leaderboard, and weekly activity.

```bash
cd app && swift build -c release
open ClaudeTrackerTracker.app
```

## How It Works

| Step | What Happens |
|------|--------------|
| Daily scan | GitHub Action searches for new trackers at 9 AM UTC |
| Discovery | New repos with 2+ stars get flagged |
| Review | Opens PR for human review (no auto-merge) |
| Update | Star counts refresh, leaderboard re-ranks |

## Add a Tracker

Know a tracker we're missing? [Open an issue](../../issues/new) or PR to `trackers.json`.

## License

MIT
