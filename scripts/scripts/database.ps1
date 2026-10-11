param(
    [ValidateSet('create','backup','restore','verify')][string]$Action = 'backup',
    [string]$PgBin = 'D:\postgresql-16.15-5-windows-x64-binaries\pgsql\bin',
    [string]$Server = '127.0.0.1',
    [int]$Port = 5434,
    [string]$Username = 'postgres',
    [string]$BackupDirectory = '',
    [string]$Database = 'lab_netmicro_policy',
    [ValidateSet('custom','sql')][string]$Format = 'custom',
    [string]$TargetDatabase = 'lab_netmicro_policy_restored'
)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
if (!$BackupDirectory) { $BackupDirectory = Join-Path $root 'artifacts/backups' }
$connection = @('-h', $Server, '-p', "$Port", '-U', $Username, '-w')
$psql = Join-Path $PgBin 'psql.exe'
$databases = @('lab_netmicro_payments','lab_netmicro_jobs','lab_netmicro_policy','lab_netmicro_pricing')
function Assert-Result { if ($LASTEXITCODE -ne 0) { throw "PostgreSQL command failed: $LASTEXITCODE" } }
if ($Action -eq 'create') {
    Push-Location -LiteralPath $root
    try {
        & $psql @connection -d postgres -v ON_ERROR_STOP=1 -f 'postgres/postgres/createdatabases.sql'
        Assert-Result
    } finally { Pop-Location }
} elseif ($Action -eq 'backup') {
    New-Item -ItemType Directory -Force -Path $BackupDirectory | Out-Null
    # Relative arguments avoid the Windows PostgreSQL CLI's Unicode path limitation.
    Push-Location -LiteralPath $BackupDirectory
    try {
        foreach ($name in $databases) {
            & (Join-Path $PgBin 'pg_dump.exe') @connection -d $name -Fc -f "$name.backup"
            Assert-Result
            & (Join-Path $PgBin 'pg_dump.exe') @connection -d $name --format=plain --no-owner --no-privileges -f "$name.sql"
            Assert-Result
            & (Join-Path $PgBin 'pg_restore.exe') -l "$name.backup" | Set-Content -Encoding UTF8 "$name.contents.txt"
            Assert-Result
        }
    } finally { Pop-Location }
    Get-ChildItem -LiteralPath $BackupDirectory -Filter '*.backup' | Get-FileHash -Algorithm SHA256 | Format-Table -AutoSize
} elseif ($Action -eq 'restore') {
    if ($TargetDatabase -notmatch '^lab_netmicro_[a-z_]+$') { throw 'Use a lab_netmicro_ target database name.' }
    # Creates a NEW target and fails if it already exists; never overwrites a database.
    & (Join-Path $PgBin 'createdb.exe') @connection $TargetDatabase
    Assert-Result
    Push-Location -LiteralPath $BackupDirectory
    try {
        if ($Format -eq 'sql') {
            & $psql @connection -d $TargetDatabase -v ON_ERROR_STOP=1 --single-transaction -f "$Database.sql"
        } else {
            & (Join-Path $PgBin 'pg_restore.exe') @connection --exit-on-error --no-owner --no-privileges -d $TargetDatabase "$Database.backup"
        }
        Assert-Result
    } finally { Pop-Location }
} else {
    & $psql @connection -d postgres -c "SELECT datname, pg_get_userbyid(datdba) AS owner FROM pg_database WHERE datname LIKE 'lab_netmicro_%' ORDER BY datname;"
    Assert-Result
}

