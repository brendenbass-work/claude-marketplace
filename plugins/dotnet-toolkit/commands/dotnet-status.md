---
description: Show whether the local .NET app is running
allowed-tools: Bash(bash:*)
disable-model-invocation: true
model: haiku
---
!`bash "${CLAUDE_PLUGIN_ROOT}/scripts/dotnet-app.sh" status`

State the status in one line.
