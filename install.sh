#!/usr/bin/env bash
set -euo pipefail

BASE_URL="https://raw.githubusercontent.com/left-code/oh-my-posh-themes/refs/heads/master/scripts"
INSTALL_DIR="$HOME/.config/oh-my-posh"

mkdir -p "$INSTALL_DIR"

echo "Installing AI usage scripts..."

curl -fsSL "$BASE_URL/ai-usage.sh" \
    -o "$INSTALL_DIR/ai-usage.sh"

curl -fsSL "$BASE_URL/ai-usage-refresh.sh" \
    -o "$INSTALL_DIR/ai-usage-refresh.sh"

chmod +x \
    "$INSTALL_DIR/ai-usage.sh" \
    "$INSTALL_DIR/ai-usage-refresh.sh"

echo "Refreshing AI usage..."

"$INSTALL_DIR/ai-usage-refresh.sh"

echo "Installed to $INSTALL_DIR"