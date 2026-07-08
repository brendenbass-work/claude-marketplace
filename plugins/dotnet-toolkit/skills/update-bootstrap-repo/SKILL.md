---
name: update-bootstrap-repo
description: This skill should be used when refreshing a repo's shared team standards to the latest version — when the user asks to update AGENTS.md, pull the latest team standards, or sync team conventions after the plugin was updated.
disable-model-invocation: true
allowed-tools: "Read, Write, Edit, Glob, Bash(git:*)"
---
# Update a repo's team standards to the latest

Replace ONLY the managed team-standards block in this repo's AGENTS.md with the latest
version from the plugin, preserving any repo-specific content the team added.

## Steps

1. Confirm you're at the repo root. Read the current repo `AGENTS.md`. If none exists,
   stop and tell the user to run /bootstrap-repo first.

2. Read the latest master standards shipped with this plugin:
   `${CLAUDE_PLUGIN_ROOT}/standards/AGENTS.md`
   Note its version from the `v<x.y.z>` in the BEGIN marker comment.

3. In the repo's AGENTS.md, locate the block between
   `<!-- BEGIN TEAM STANDARDS ... -->` and `<!-- END TEAM STANDARDS -->`:
   - If the markers exist: replace EVERYTHING between and including them with the master
     block. Leave all content outside the markers (repo-specific additions) untouched.
   - If the markers do NOT exist: the file predates managed standards. Show the user a diff
     of what would be added, and on confirmation, prepend the master block above their
     existing content rather than replacing anything.

4. Report: old version -> new version, and confirm repo-specific content outside the
   markers was preserved. Remind the user to review and `git commit`. Do NOT commit.

Only ever touch the marker-delimited block. Never delete repo-specific content. Never commit automatically.
