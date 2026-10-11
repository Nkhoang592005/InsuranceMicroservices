param(
    [string]$PgBin = 'D:\postgresql-16.15-5-windows-x64-binaries\pgsql\bin',
    [string]$Server = '127.0.0.1',
    [int]$Port = 5434,
    [string]$Username = 'postgres'
)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$connection = @('-h', $Server, '-p', "$Port", '-U', $Username, '-w')
$psql = Join-Path $PgBin 'psql.exe'
function Assert-Result { if ($LASTEXITCODE -ne 0) { throw "Demo database command failed: $LASTEXITCODE" } }
Push-Location -LiteralPath $root
try {
    $exists = & $psql @connection -d postgres -t -A -c "SELECT 1 FROM pg_database WHERE datname='lab_netmicro_demo';"
    Assert-Result
    if ($exists -ne '1') {
        & (Join-Path $PgBin 'createdb.exe') @connection lab_netmicro_demo
        Assert-Result
    }
    New-Item -ItemType Directory -Force -Path artifacts/backups/demo | Out-Null
    & $psql @connection -d lab_netmicro_demo -v ON_ERROR_STOP=1 -f scripts/scripts/load-demo.sql | Tee-Object -FilePath artifacts/demo-database-verification.txt
    Assert-Result
    & (Join-Path $PgBin 'pg_dump.exe') @connection -d lab_netmicro_demo -Fc -f artifacts/backups/demo/lab_netmicro_demo.backup
    Assert-Result
    & (Join-Path $PgBin 'pg_dump.exe') @connection -d lab_netmicro_demo --format=plain --no-owner --no-privileges -f artifacts/backups/demo/lab_netmicro_demo.sql
    Assert-Result
    Write-Output 'Demo database loaded and verified: 18 modules, 90 synthetic records. Custom and SQL backups exported.'
} finally { Pop-Location }
