---
description: Stop the local .NET app started by /dotnet-start
allowed-tools: Bash(bash:*)
disable-model-invocation: true
model: haiku
---
!`bash "${CLAUDE_PLUGIN_ROOT}/scripts/dotnet-app.sh" stop`

Confirm from the output whether it stopped.
