---
description: Open the current repo in VS Code (WSL)
allowed-tools: Bash(code:*)
disable-model-invocation: true
model: haiku
---
!`code .`

Confirm VS Code was launched from the output above. If it shows "command not found",
tell me the `code` CLI isn't on PATH in this WSL shell and stop — don't try to install it.
