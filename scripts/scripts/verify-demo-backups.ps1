param(
    [string]$PgBin = 'D:\postgresql-16.15-5-windows-x64-binaries\pgsql\bin',
    [string]$Server = '127.0.0.1',
    [int]$Port = 5434,
    [string]$Username = 'postgres'
)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
$connection = @('-h', $Server, '-p', "$Port", '-U', $Username, '-w')
function Assert-Result { if ($LASTEXITCODE -ne 0) { throw "Demo restore verification failed: $LASTEXITCODE" } }
$suffix = [Guid]::NewGuid().ToString('N').Substring(0,8)
Push-Location -LiteralPath $root
try {
    foreach ($format in @('custom','sql')) {
        $target = "lab_netmicro_demo_${format}_$suffix"
        & (Join-Path $PgBin 'createdb.exe') @connection $target
        Assert-Result
        if ($format -eq 'custom') {
            & (Join-Path $PgBin 'pg_restore.exe') @connection --exit-on-error --no-owner --no-privileges -d $target artifacts/backups/demo/lab_netmicro_demo.backup
        } else {
            & (Join-Path $PgBin 'psql.exe') @connection -d $target -v ON_ERROR_STOP=1 --single-transaction -f artifacts/backups/demo/lab_netmicro_demo.sql
        }
        Assert-Result
        & (Join-Path $PgBin 'psql.exe') @connection -d $target -v ON_ERROR_STOP=1 -f scripts/scripts/verify-demo.sql | Tee-Object -FilePath "artifacts/demo-restore-$format.txt"
        Assert-Result
        Write-Output "Verified $format restore in NEW database $target (18 tables, 90 demo records)."
    }
} finally { Pop-Location }
