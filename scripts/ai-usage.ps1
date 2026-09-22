$cacheDir  = Join-Path $HOME ".cache\ai-usage"
$cacheFile = Join-Path $cacheDir "usage.txt"
$stampFile = Join-Path $cacheDir "updated.txt"
$ttl       = [TimeSpan]::FromMinutes(5)

New-Item -ItemType Directory -Force -Path $cacheDir | Out-Null

$needsRefresh = $true

if (Test-Path $stampFile) {
    try {
        $lastUpdate = [DateTime]::Parse(
            (Get-Content $stampFile -Raw),
            [cultureinfo]::InvariantCulture,
            [Globalization.DateTimeStyles]::RoundtripKind
        )

        $needsRefresh = ((Get-Date) - $lastUpdate) -gt $ttl
    }
    catch {
        $needsRefresh = $true
    }
}

if (Test-Path $cacheFile) {
    $cached = (Get-Content $cacheFile -Raw).Trim()

    if ($cached) {
        Write-Output $cached
    }
}

if ($needsRefresh) {
    $refreshScript = Join-Path $PSScriptRoot "ai-usage-refresh.ps1"

    if (Test-Path $refreshScript) {
        Start-Process pwsh `
            -WindowStyle Hidden `
            -ArgumentList @(
                "-NoLogo",
                "-NoProfile",
                "-NonInteractive",
                "-File",
                "`"$refreshScript`""
            )
    }
}