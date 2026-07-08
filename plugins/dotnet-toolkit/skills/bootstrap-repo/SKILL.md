---
name: bootstrap-repo
description: This skill should be used when setting up a new or existing repo with our team's shared AI standards — when the user asks to bootstrap a repo, add team standards, add AGENTS.md, or standardize a repo for Claude Code and Copilot.
disable-model-invocation: true
allowed-tools: "Read, Write, Edit, Glob, Bash(git:*)"
---
# Bootstrap a repo with team standards

Stamp the shared team standards into the current repository so both Claude Code and
GitHub Copilot follow them. Idempotent — safe to run on a repo that's partially set up.

## Steps

1. Confirm you're at the repo root (a `.git` directory is present). If not, stop and say so.

2. Read the master standards shipped with this plugin:
   `${CLAUDE_PLUGIN_ROOT}/standards/AGENTS.md`

3. Handle **AGENTS.md** at the repo root:
   - If it does NOT exist: create it with the master content verbatim.
   - If it EXISTS and already contains the markers `<!-- BEGIN TEAM STANDARDS ... -->` and
     `<!-- END TEAM STANDARDS -->`: leave it — tell the user it's already bootstrapped and to
     run /update-bootstrap-repo to refresh.
   - If it EXISTS with NO markers (a hand-written AGENTS.md): do NOT overwrite. Prepend the
     master TEAM STANDARDS block (the marker-delimited section) above their existing content,
     so both are preserved.

4. Ensure **CLAUDE.md** imports it: if CLAUDE.md exists and has no `@AGENTS.md` line, add
   `@AGENTS.md` near the top. If CLAUDE.md does not exist, create a minimal one:
   ```
   # <RepoName>

   @AGENTS.md

   ## This repo
   - TODO: build command, key subsystems, private packages, landmines
   ```

5. Ensure **.gitignore** contains `.claude/settings.local.json` (append if missing).

6. Summarize what you created/changed and remind the user to review and `git commit`
   (but do NOT commit for them). List the TODOs they should fill in.

Never overwrite hand-written content outside the marker block. Never commit automatically.
