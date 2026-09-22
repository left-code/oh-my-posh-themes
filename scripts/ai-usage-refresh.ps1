$ErrorActionPreference = "SilentlyContinue"

$cacheDir  = Join-Path $HOME ".cache\ai-usage"
$cacheFile = Join-Path $cacheDir "usage.txt"
$stampFile = Join-Path $cacheDir "updated.txt"
$lockFile  = Join-Path $cacheDir "refresh.lock"

New-Item -ItemType Directory -Force -Path $cacheDir | Out-Null

$lock = $null

try {
    $lock = [System.IO.File]::Open(
        $lockFile,
        [System.IO.FileMode]::OpenOrCreate,
        [System.IO.FileAccess]::ReadWrite,
        [System.IO.FileShare]::None
    )
}
catch {
    exit 0
}

try {
    $codex  = codex-cli-usage json | ConvertFrom-Json
    $claude = ccusage json | ConvertFrom-Json

    $parts = @()

    if ($null -ne $codex.'5h' -and $null -ne $codex.'7d') {
        $parts += ">_ $([int]$codex.'5h'.pct)/$([int]$codex.'7d'.pct)%"
    }

    if ($null -ne $claude.session -and $null -ne $claude.'7d') {
        $parts += "◈ $([int]$claude.session.pct)/$([int]$claude.'7d'.pct)%"
    }

    if ($parts.Count -gt 0) {
        # Use explicit UTF-8 without BOM.
        # Do not depend on PowerShell's version-specific Set-Content defaults.
        $utf8 = New-Object System.Text.UTF8Encoding($false)

        [System.IO.File]::WriteAllText(
            $cacheFile,
            ($parts -join "  "),
            $utf8
        )

        [System.IO.File]::WriteAllText(
            $stampFile,
            (Get-Date).ToString("O"),
            $utf8
        )
    }
}
finally {
    if ($null -ne $lock) {
        $lock.Dispose()
    }

    Remove-Item $lockFile -Force -ErrorAction SilentlyContinue
}