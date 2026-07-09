---
description: Rebuild, then restart the local .NET app (keeps the old instance up if the build fails)
allowed-tools: Bash(bash:*)
disable-model-invocation: true
model: haiku
---
!`bash "${CLAUDE_PLUGIN_ROOT}/scripts/dotnet-app.sh" restart`

From the output: if the build FAILED, the previous instance is still running —
show the compiler errors and stop. If it succeeded, confirm the app came back up.
