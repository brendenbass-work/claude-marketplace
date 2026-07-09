---
description: Start the local .NET app in the background (this repo)
allowed-tools: Bash(bash:*)
disable-model-invocation: true
model: haiku
argument-hint: "(optional) leave empty to auto-detect the project"
---
!`bash "${CLAUDE_PLUGIN_ROOT}/scripts/dotnet-app.sh" start`

From the output above, confirm whether the app started. If it FAILED, show the
relevant error lines and stop — do not retry or edit code automatically.
If the project was ambiguous, tell me to re-run with DOTNET_PROJECT set.
