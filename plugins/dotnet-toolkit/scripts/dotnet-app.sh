#!/usr/bin/env bash
# dotnet-app.sh — lifecycle for a local .NET app, driven by the /dotnet-* slash commands.
# Runs the app as a DETACHED process group so `dotnet run`'s child (dotnet exec ...)
# is killed on stop, and so it survives Claude Code session compaction
# (it is not registered as a Claude Code background task).
#
# Project selection (in order):
#   1. DOTNET_APP_CMD  — full launch command override; used verbatim.
#                        e.g. 'dotnet watch run --project ./src/Api' or 'dotnet ./bin/Debug/net8.0/Api.dll'
#   2. DOTNET_PROJECT  — explicit path to a .csproj or project dir.
#   3. Auto-detect     — the single runnable (.Sdk.Web or OutputType=Exe) .csproj under the cwd.
#
# State (PID + log) lives in $PWD/.claude/run by default, so each repo is independent.
# Override with DOTNET_APP_STATE_DIR.
#
# Usage: dotnet-app.sh {start|stop|restart|status|logs}

set -uo pipefail

STATE_DIR="${DOTNET_APP_STATE_DIR:-$PWD/.claude/run}"
PID_FILE="$STATE_DIR/dotnet-app.pgid"
LOG_FILE="$STATE_DIR/dotnet-app.log"
mkdir -p "$STATE_DIR"

_alive() { [[ -f "$PID_FILE" ]] && kill -0 "-$(cat "$PID_FILE")" 2>/dev/null; }

_find_csprojs() {
  find . -maxdepth 4 -name '*.csproj' -not -path '*/bin/*' -not -path '*/obj/*' 2>/dev/null
}

_resolve_project() {
  if [[ -n "${DOTNET_PROJECT:-}" ]]; then echo "$DOTNET_PROJECT"; return 0; fi
  local all=() runnable=() f
  while IFS= read -r f; do [[ -n "$f" ]] && all+=("$f"); done < <(_find_csprojs)
  for f in "${all[@]}"; do
    if grep -qiE 'Sdk="Microsoft\.NET\.Sdk\.Web"|<OutputType>[[:space:]]*Exe' "$f"; then runnable+=("$f"); fi
  done
  local pick=("${runnable[@]}")
  [[ ${#pick[@]} -eq 0 ]] && pick=("${all[@]}")
  if [[ ${#pick[@]} -eq 1 ]]; then echo "${pick[0]}"; return 0; fi
  return 1
}

_build_run_cmd() {
  if [[ -n "${DOTNET_APP_CMD:-}" ]]; then printf '%s' "$DOTNET_APP_CMD"; return 0; fi
  local proj
  if ! proj="$(_resolve_project)"; then
    echo "ERR: couldn't pick a runnable project automatically." >&2
    echo "Set DOTNET_PROJECT=./path/to/Project (or DOTNET_APP_CMD). Candidates found:" >&2
    _find_csprojs | sed 's/^/  /' >&2
    return 1
  fi
  printf 'dotnet run --project "%s"' "$proj"
}

start() {
  if _alive; then
    echo "Already running (pgid $(cat "$PID_FILE")). Use restart to reload."
    return 0
  fi
  local run_cmd
  run_cmd="$(_build_run_cmd)" || return 1
  : > "$LOG_FILE"
  # setsid → new session/group whose leader PID == PGID. Fully detached, so it is
  # NOT tracked as a Claude Code background task and survives session compaction.
  setsid bash -c "exec $run_cmd" >>"$LOG_FILE" 2>&1 &
  local pgid=$!
  echo "$pgid" > "$PID_FILE"
  sleep 1  # fail fast on build/bind errors
  if _alive; then
    echo "Started (pgid $pgid)."
    echo "Command: $run_cmd"
    echo "Logs:    $LOG_FILE"
  else
    echo "FAILED to start. Last log lines:"
    tail -n 20 "$LOG_FILE" 2>/dev/null || true
    rm -f "$PID_FILE"
    return 1
  fi
}

stop() {
  if [[ ! -f "$PID_FILE" ]]; then echo "No PID file at $PID_FILE; nothing to stop."; return 0; fi
  local pgid; pgid="$(cat "$PID_FILE")"
  if kill -0 "-$pgid" 2>/dev/null; then
    kill -TERM "-$pgid" 2>/dev/null || true
    for _ in $(seq 1 10); do kill -0 "-$pgid" 2>/dev/null || break; sleep 0.5; done
    if kill -0 "-$pgid" 2>/dev/null; then
      kill -KILL "-$pgid" 2>/dev/null || true; echo "Force-killed pgid $pgid."
    else
      echo "Stopped pgid $pgid."
    fi
  else
    echo "Process group $pgid not running (stale PID file)."
  fi
  rm -f "$PID_FILE"
}

status() { if _alive; then echo "RUNNING (pgid $(cat "$PID_FILE"))"; else echo "STOPPED"; fi; }
logs()   { tail -n "${2:-40}" "$LOG_FILE" 2>/dev/null || echo "No log file yet at $LOG_FILE"; }

# Build-gated restart: compile FIRST; only cycle the server if the build succeeds,
# so a broken build never takes down the instance that's already running.
# Config via DOTNET_CONFIG (default Debug).
restart() {
  if [[ -n "${DOTNET_APP_CMD:-}" ]]; then
    echo "DOTNET_APP_CMD is set; can't infer a build target. Cycling without pre-build."
    stop; start; return $?
  fi
  local proj rc
  if ! proj="$(_resolve_project)"; then
    echo "ERR: couldn't pick a project to build." >&2
    _find_csprojs | sed 's/^/  /' >&2
    return 1
  fi
  rc="${DOTNET_CONFIG:-Debug}"
  echo "Building $proj ($rc) ..."
  if dotnet build "$proj" -c "$rc" --nologo >"$STATE_DIR/build.log" 2>&1; then
    echo "Build OK. Cycling app ..."
    stop
    # Reuse the fresh build to avoid a redundant compile on run.
    DOTNET_APP_CMD="dotnet run --no-build -c $rc --project \"$proj\"" start
  else
    echo "BUILD FAILED — leaving the running instance up. Tail of build log:"
    tail -n 25 "$STATE_DIR/build.log" 2>/dev/null || true
    return 1
  fi
}

case "${1:-}" in
  start)   start ;;
  stop)    stop ;;
  restart) restart ;;
  status)  status ;;
  logs)    logs "$@" ;;
  *) echo "Usage: dotnet-app.sh {start|stop|restart|status|logs}" >&2; exit 2 ;;
esac
