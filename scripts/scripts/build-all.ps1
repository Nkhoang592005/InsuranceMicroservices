param([switch]$SkipTests)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
& (Join-Path $PSScriptRoot 'build.ps1') -SkipTests:$SkipTests
& (Join-Path $PSScriptRoot 'build-eureka.ps1') -SkipTests:$SkipTests
$previousNodeOptions = $env:NODE_OPTIONS
Push-Location -LiteralPath (Join-Path $root 'Web/Web')
try {
    & npm.cmd ci --no-audit --no-fund
    if ($LASTEXITCODE -ne 0) { throw 'Vue dependency installation failed.' }
    $env:NODE_OPTIONS = '--openssl-legacy-provider'
    # Merge native stderr inside cmd so PowerShell 5 does not turn warnings into terminating errors.
    & cmd.exe /d /c 'npm run build 2>&1' | Tee-Object -FilePath (Join-Path $root 'artifacts/vue-build-output.txt')
    if ($LASTEXITCODE -ne 0) { throw 'Vue build failed.' }
} finally {
    $env:NODE_OPTIONS = $previousNodeOptions
    Pop-Location
}
foreach ($file in @('infra.yml','app.yml')) {
    & docker compose -f (Join-Path $PSScriptRoot $file) config --quiet
    if ($LASTEXITCODE -ne 0) { throw "Invalid Docker Compose configuration: $file" }
}
Write-Output 'All source builds and Docker Compose configuration checks passed.'
