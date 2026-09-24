$ErrorActionPreference = "SilentlyContinue"

$cacheDir  = Join-Path $HOME ".cache\ai-usage"
$cacheFile = Join-Path $cacheDir "usage.txt"
$stampFile = Join-Path $cacheDir "updated.txt"
$lockFile  = Join-Path $cacheDir "refresh.lock"
$logFile   = Join-Path $cacheDir "refresh.log"

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
    # Use explicit UTF-8 without BOM.
    # Do not depend on PowerShell's version-specific Set-Content defaults.
    $utf8 = New-Object System.Text.UTF8Encoding($false)

    # Each provider keeps its last good value, so one failed fetch
    # (e.g. an expired Claude OAuth token) does not drop it from the prompt.
    function Update-Part($name, $command, $format) {
        $partFile = Join-Path $cacheDir "$name.txt"
        $output = & $command 2>&1
        $json = $output | Where-Object { $_ -isnot [System.Management.Automation.ErrorRecord] } | Out-String
        $data = if ($json.Trim()) { $json | ConvertFrom-Json } else { $null }
        $part = if ($null -ne $data) { & $format $data } else { $null }

        if ($part) {
            [System.IO.File]::WriteAllText($partFile, $part, $utf8)
        }
        else {
            $errors = $output | Where-Object { $_ -is [System.Management.Automation.ErrorRecord] } | Out-String
            [System.IO.File]::AppendAllText(
                $logFile,
                "$((Get-Date).ToString('O')) $name failed: $($errors.Trim())`n",
                $utf8
            )
        }

        if (Test-Path $partFile) {
            return (Get-Content $partFile -Raw).Trim()
        }
    }

    $parts = @(
        Update-Part "codex" { codex-cli-usage json } {
            param($d)
            if ($null -ne $d.'5h' -and $null -ne $d.'7d') {
                ">_ $([int]$d.'5h'.pct)/$([int]$d.'7d'.pct)%"
            }
        }
        Update-Part "claude" { ccusage json } {
            param($d)
            if ($null -ne $d.session -and $null -ne $d.'7d') {
                "$([char]0x25C8) $([int]$d.session.pct)/$([int]$d.'7d'.pct)%"
            }
        }
    ) | Where-Object { $_ }

    if ($parts.Count -gt 0) {
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