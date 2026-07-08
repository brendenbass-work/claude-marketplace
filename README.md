# MCPS Internal Claude Code Marketplace

A Claude Code plugin marketplace for the TIS web team. One plugin today: **dotnet-toolkit**.

## What's in dotnet-toolkit
- **ui-component** — Razor + Bootstrap 5 UI conventions (auto-invoked when building UI)
- **bootstrap-repo** — `/bootstrap-repo` stamps our shared AGENTS.md into a repo (for Claude Code AND Copilot) and wires CLAUDE.md to import it
- **update-bootstrap-repo** — `/update-bootstrap-repo` refreshes only the managed standards block, preserving repo-specific edits
- **standards/AGENTS.md** — the single master copy of our .NET team conventions

## Install (each teammate, once)
```
/plugin marketplace add <your-org>/claude-marketplace
/plugin install dotnet-toolkit@mcps-internal
```
Then per repo: `/bootstrap-repo`, review, and commit the AGENTS.md + CLAUDE.md it creates.

## Updating the standards for everyone
1. Edit `plugins/dotnet-toolkit/standards/AGENTS.md` (keep the BEGIN/END markers).
2. Bump `version` in the BEGIN marker comment AND in `plugin.json`.
3. Commit + push. Teammates get it via `/plugin` update, then run `/update-bootstrap-repo`
   in each repo to pull the new standards block (their repo-specific notes are preserved).

## How the split works (important)
- **Plugin** ships behavior (skills) + the master standards file.
- **AGENTS.md lives committed at each repo root** — because Copilot reads it there and it's
  reviewable per-repo. The plugin doesn't inject it live; the bootstrap skills COPY it in.
- A plugin-level CLAUDE.md is ignored by Claude Code — SKILL.md files are the right mechanism.

## Local testing before you push
```
claude --plugin-dir ./plugins/dotnet-toolkit
```
Loads the plugin for one session so you can test the three skills without installing.
