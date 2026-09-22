#!/usr/bin/env bash

CACHE_DIR="$HOME/.cache/ai-usage"
CACHE_FILE="$CACHE_DIR/usage.txt"
STAMP_FILE="$CACHE_DIR/updated.txt"
REFRESH_SCRIPT="$HOME/.config/oh-my-posh/ai-usage-refresh.sh"

TTL=300 # 5 minutes

mkdir -p "$CACHE_DIR"

needs_refresh=true

if [[ -f "$STAMP_FILE" ]]; then
    updated_epoch=$(date -d "$(cat "$STAMP_FILE")" +%s 2>/dev/null || echo 0)
    now_epoch=$(date +%s)

    if (( now_epoch - updated_epoch < TTL )); then
        needs_refresh=false
    fi
fi

# Return cached value immediately.
if [[ -s "$CACHE_FILE" ]]; then
    cat "$CACHE_FILE"
fi

# Refresh asynchronously when stale.
if [[ "$needs_refresh" == true && -x "$REFRESH_SCRIPT" ]]; then
    nohup "$REFRESH_SCRIPT" >/dev/null 2>&1 &
fi