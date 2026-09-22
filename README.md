# Oh My Posh Themes

Custom [Oh My Posh](https://ohmyposh.dev/) themes with Git, system, runtime, and AI usage information.

## Blue Owl

`blue-owl.omp.json` is a compact theme for PowerShell and Zsh.

### AI Usage

The theme displays current Codex and Claude usage:

```text
>_ 74/12%  ◈ 100/49%
```

- `>_` — Codex
- `◈` — Claude
- First value — current 5-hour/session usage
- Second value — 7-day usage

Usage data is cached locally and refreshed asynchronously every 5 minutes to keep prompt rendering fast.

## Requirements

Install [Oh My Posh](https://ohmyposh.dev/), `uv`, Codex CLI, and Claude Code.

Codex and Claude Code must be authenticated.

Install the usage collectors:

```shell
uv tool install codex-cli-usage
uv tool install ccusage
```

## Windows / PowerShell

Install the local AI usage scripts:

```powershell
irm https://raw.githubusercontent.com/left-code/oh-my-posh-themes/refs/heads/master/install.ps1 | iex
```

Add to `$PROFILE`:

```powershell
oh-my-posh init pwsh --config "https://raw.githubusercontent.com/left-code/oh-my-posh-themes/refs/heads/master/blue-owl.omp.json" | Invoke-Expression

& "$HOME/.config/oh-my-posh/ai-usage.ps1" | Out-Null
```

Reload the profile:

```powershell
. $PROFILE
```

## Linux / WSL / Zsh

The Linux implementation uses native shell scripts and does not require PowerShell.

### Dependencies

On Ubuntu/Debian:

```bash
sudo apt update
sudo apt install -y curl jq util-linux
```

Install the AI usage collectors if they are not already installed:

```bash
uv tool install codex-cli-usage
uv tool install ccusage
```

Install the local AI usage scripts:

```bash
curl -fsSL https://raw.githubusercontent.com/left-code/oh-my-posh-themes/refs/heads/master/install.sh | bash
```

The installer checks all required dependencies before making changes.

Add to `~/.zshrc`:

```zsh
eval "$(oh-my-posh init zsh --config 'https://raw.githubusercontent.com/left-code/oh-my-posh-themes/refs/heads/master/blue-owl.omp.json')"

"$HOME/.config/oh-my-posh/ai-usage.sh" >/dev/null 2>&1
```

Reload Zsh:

```bash
source ~/.zshrc
```

## How It Works

The prompt reads AI usage from:

```text
~/.cache/ai-usage/usage.txt
```

For example:

```text
>_ 74/12%  ◈ 100/49%
```

The cache is returned immediately. If it is older than 5 minutes, a background refresh retrieves new Codex and Claude usage without blocking prompt rendering.

## Repository

```text
.
├── blue-owl.omp.json
├── install.ps1
├── install.sh
└── scripts/
    ├── ai-usage.ps1
    ├── ai-usage-refresh.ps1
    ├── ai-usage.sh
    └── ai-usage-refresh.sh
```

Platform-specific scripts use the same cache contract:

```text
Windows       ai-usage.ps1
Linux / WSL   ai-usage.sh
                   │
                   ▼
        ~/.cache/ai-usage/usage.txt
                   │
                   ▼
          blue-owl.omp.json
```

No Codex or Claude credentials are stored by this repository.