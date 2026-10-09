# Oh My Posh Themes

Custom [Oh My Posh](https://ohmyposh.dev/) themes with Git, system, and runtime information.

## Blue Owl

`blue-owl.omp.json` is a compact theme for PowerShell and Zsh.

## How it looks

![alt text](assets/pwsh.png)
![alt text](assets/powershell.png)
![alt text](assets/wsl.png)

## Requirements

Install [Oh My Posh](https://ohmyposh.dev/).

## Windows / PowerShell

Add to `$PROFILE`:

```powershell
oh-my-posh init pwsh --config "https://raw.githubusercontent.com/left-code/oh-my-posh-themes/refs/heads/master/blue-owl.omp.json" | Invoke-Expression
```

Reload the profile:

```powershell
. $PROFILE
```

## Linux / WSL / Zsh

Add to `~/.zshrc`:

```zsh
eval "$(oh-my-posh init zsh --config 'https://raw.githubusercontent.com/left-code/oh-my-posh-themes/refs/heads/master/blue-owl.omp.json')"
```

Reload Zsh:

```bash
source ~/.zshrc
```
