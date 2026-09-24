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

LOG_FILE="$CACHE_DIR/refresh.log"

parts=()

# Each provider keeps its last good value, so one failed fetch
# (e.g. an expired Claude OAuth token) does not drop it from the prompt.
# Usage: update_part <name> <command> <jq filter producing the part or empty>
update_part() {
    local name=$1 cmd=$2 filter=$3
    local part_file="$CACHE_DIR/$name.txt"
    local json part="" err_file

    if command -v "$cmd" >/dev/null 2>&1; then
        err_file=$(mktemp)
        json=$("$cmd" json 2>"$err_file" || true)

        if [[ -n "$json" ]]; then
            part=$(jq -r "$filter" <<< "$json" 2>/dev/null || true)
        fi

        if [[ -n "$part" ]]; then
            printf '%s' "$part" > "$part_file"
        else
            printf '%s %s failed: %s
' "$(date --iso-8601=seconds)" "$name" "$(tr '
' ' ' < "$err_file")" >> "$LOG_FILE"
        fi

        rm -f "$err_file"
    fi

    if [[ -s "$part_file" ]]; then
        parts+=("$(cat "$part_file")")
    fi
}

update_part codex codex-cli-usage \
    'if ."5h".pct != null and ."7d".pct != null then ">_ \(."5h".pct | floor)/\(."7d".pct | floor)%" else empty end'

update_part claude ccusage \
    'if .session.pct != null and ."7d".pct != null then "◈ \(.session.pct | floor)/\(."7d".pct | floor)%" else empty end'

# Do not overwrite a valid cache if both providers have never succeeded.
if (( ${#parts[@]} > 0 )); then
    out=${parts[0]}
    for p in "${parts[@]:1}"; do out+="  $p"; done
    printf '%s' "$out" > "$CACHE_FILE"
    date --iso-8601=seconds > "$STAMP_FILE"
fi
