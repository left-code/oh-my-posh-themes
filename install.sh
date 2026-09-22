#!/usr/bin/env bash

set -euo pipefail

BASE_URL="https://raw.githubusercontent.com/left-code/oh-my-posh-themes/refs/heads/master/scripts"
INSTALL_DIR="$HOME/.config/oh-my-posh"

required_commands=(
    curl
    jq
    flock
    codex-cli-usage
    ccusage
)

missing=()

for command_name in "${required_commands[@]}"; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
        missing+=("$command_name")
    fi
done

if (( ${#missing[@]} > 0 )); then
    echo "Missing required commands:"
    printf '  - %s\n' "${missing[@]}"
    echo
    echo "Install the missing dependencies and run this installer again."
    echo
    echo "Ubuntu/Debian system dependencies:"
    echo "  sudo apt install curl jq util-linux"
    echo
    echo "AI usage collectors:"
    echo "  uv tool install codex-cli-usage"
    echo "  uv tool install ccusage"
    exit 1
fi

mkdir -p "$INSTALL_DIR"

echo "Installing AI usage scripts..."

curl -fsSL \
    "$BASE_URL/ai-usage.sh" \
    -o "$INSTALL_DIR/ai-usage.sh"

curl -fsSL \
    "$BASE_URL/ai-usage-refresh.sh" \
    -o "$INSTALL_DIR/ai-usage-refresh.sh"

chmod +x \
    "$INSTALL_DIR/ai-usage.sh" \
    "$INSTALL_DIR/ai-usage-refresh.sh"

echo "Refreshing AI usage..."

"$INSTALL_DIR/ai-usage-refresh.sh"

echo
echo "Installed:"
echo "  $INSTALL_DIR/ai-usage.sh"
echo "  $INSTALL_DIR/ai-usage-refresh.sh"

echo
echo "Current usage:"

if [[ -f "$HOME/.cache/ai-usage/usage.txt" ]]; then
    cat "$HOME/.cache/ai-usage/usage.txt"
    echo
else
    echo "  Usage data is not available yet."
fi