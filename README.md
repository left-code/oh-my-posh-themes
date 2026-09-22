# Oh My Posh Themes

Custom [Oh My Posh](https://ohmyposh.dev/) themes for PowerShell.

## Blue Owl

`blue-owl.omp.json` is a compact PowerShell theme with Git, memory, runtime, and AI usage information.

### AI Usage

The theme can display current Codex and Claude usage instead of CPU usage:

```text
>_ 74/12%  ◈ 100/49%
```

* `>_` — Codex
* `◈` — Claude
* First value — current 5-hour/session usage
* Second value — 7-day usage

Usage data is cached locally and refreshed asynchronously every 5 minutes to keep prompt rendering fast.

### Requirements

Install:

```powershell
uv tool install codex-cli-usage
uv tool install ccusage
```

Then install the local AI usage scripts:

```powershell
irm https://raw.githubusercontent.com/left-code/oh-my-posh-themes/refs/heads/master/install.ps1 | iex
```

### PowerShell Profile

Add the following to `$PROFILE`:

```powershell
oh-my-posh init pwsh --config "https://raw.githubusercontent.com/left-code/oh-my-posh-themes/refs/heads/master/blue-owl.omp.json" | Invoke-Expression
```

Restart PowerShell or reload your profile:

```powershell
. $PROFILE
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

The AI usage scripts are installed locally under `~/.config/oh-my-posh/`. No Codex or Claude credentials are stored by this repository.
