#!/usr/bin/env bash

set -u

CACHE_DIR="$HOME/.cache/ai-usage"
CACHE_FILE="$CACHE_DIR/usage.txt"
STAMP_FILE="$CACHE_DIR/updated.txt"
LOCK_FILE="$CACHE_DIR/refresh.lock"

mkdir -p "$CACHE_DIR"

# Prevent multiple terminals from refreshing at the same time.
exec 9>"$LOCK_FILE"

if ! flock -n 9; then
    exit 0
fi

parts=()

# Codex
if command -v codex-cli-usage >/dev/null 2>&1; then
    codex_json=$(codex-cli-usage json 2>/dev/null || true)

    if [[ -n "$codex_json" ]]; then
        codex_5h=$(jq -r '."5h".pct // empty' <<< "$codex_json")
        codex_7d=$(jq -r '."7d".pct // empty' <<< "$codex_json")

        if [[ -n "$codex_5h" && -n "$codex_7d" ]]; then
            parts+=(">_ ${codex_5h}/${codex_7d}%")
        fi
    fi
fi

# Claude
if command -v ccusage >/dev/null 2>&1; then
    claude_json=$(ccusage json 2>/dev/null || true)

    if [[ -n "$claude_json" ]]; then
        claude_session=$(jq -r '.session.pct // empty' <<< "$claude_json")
        claude_7d=$(jq -r '."7d".pct // empty' <<< "$claude_json")

        if [[ -n "$claude_session" && -n "$claude_7d" ]]; then
            parts+=("◈ ${claude_session}/${claude_7d}%")
        fi
    fi
fi

# Do not overwrite a valid cache if both providers failed.
if (( ${#parts[@]} > 0 )); then
    printf '%s' "$(IFS='  '; echo "${parts[*]}")" > "$CACHE_FILE"
    date --iso-8601=seconds > "$STAMP_FILE"
fi