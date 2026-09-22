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

Usage is cached locally and refreshed asynchronously every 5 minutes to keep prompt rendering fast.

## Requirements

Install [Oh My Posh](https://ohmyposh.dev/) and `uv`, then install the usage collectors:

```shell
uv tool install codex-cli-usage
uv tool install ccusage
```

Codex CLI and Claude Code must be installed and authenticated.

## Install AI Usage Scripts

### Windows / PowerShell

```powershell
irm https://raw.githubusercontent.com/left-code/oh-my-posh-themes/refs/heads/master/install.ps1 | iex
```

### Linux / WSL

```bash
curl -fsSL https://raw.githubusercontent.com/left-code/oh-my-posh-themes/refs/heads/master/install.sh | bash
```

The scripts are installed to:

```text
~/.config/oh-my-posh/
```

## Shell Configuration

### PowerShell

Add to `$PROFILE`:

```powershell
oh-my-posh init pwsh --config "https://raw.githubusercontent.com/left-code/oh-my-posh-themes/refs/heads/master/blue-owl.omp.json" | Invoke-Expression

& "$HOME/.config/oh-my-posh/ai-usage.ps1" | Out-Null
```

Reload:

```powershell
. $PROFILE
```

### Zsh / WSL

Add to `~/.zshrc`:

```zsh
eval "$(oh-my-posh init zsh --config 'https://raw.githubusercontent.com/left-code/oh-my-posh-themes/refs/heads/master/blue-owl.omp.json')"

"$HOME/.config/oh-my-posh/ai-usage.sh" >/dev/null 2>&1
```

Reload:

```bash
source ~/.zshrc
```

## Repository

```text
.
├── blue-owl.omp.json
├── install.ps1
└── scripts/
    ├── ai-usage.ps1
    └── ai-usage-refresh.ps1
```

AI usage is stored in a small local cache under:

```text
~/.cache/ai-usage/
```

No Codex or Claude credentials are stored by this repository.