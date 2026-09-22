$ErrorActionPreference = "Stop"

$baseUrl = "https://raw.githubusercontent.com/left-code/oh-my-posh-themes/refs/heads/master/scripts"
$installDir = Join-Path $HOME ".config\oh-my-posh"

New-Item -ItemType Directory -Force -Path $installDir | Out-Null

$scripts = @(
    "ai-usage.ps1",
    "ai-usage-refresh.ps1"
)

foreach ($script in $scripts) {
    $uri = "$baseUrl/$script"
    $destination = Join-Path $installDir $script

    Write-Host "Installing $script..."
    Invoke-WebRequest -Uri $uri -OutFile $destination
}

Write-Host "Refreshing AI usage..."

& (Join-Path $installDir "ai-usage-refresh.ps1")

Write-Host "Installed to $installDir"