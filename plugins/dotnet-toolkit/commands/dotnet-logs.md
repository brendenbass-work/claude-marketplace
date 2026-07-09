---
description: Show the last 40 lines of the local .NET app log
allowed-tools: Bash(bash:*)
disable-model-invocation: true
model: haiku
---
!`bash "${CLAUDE_PLUGIN_ROOT}/scripts/dotnet-app.sh" logs`

Summarize anything notable (errors, the bound URL). Otherwise just show them.
