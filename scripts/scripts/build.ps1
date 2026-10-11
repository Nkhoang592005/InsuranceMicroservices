param([switch]$SkipTests)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
Push-Location -LiteralPath $root
try {
    New-Item -ItemType Directory -Force artifacts | Out-Null
    & dotnet build InsuranceMicroservices.slnx -m:1 --nologo 2>&1 | Tee-Object -FilePath artifacts/build-output.txt
    if ($LASTEXITCODE -ne 0) { throw 'Solution build failed.' }
    if (!$SkipTests) {
        $reports = Join-Path $root 'artifacts/tests'
        if (Test-Path -LiteralPath $reports) {
            Get-ChildItem -LiteralPath $reports -Filter '*.trx' -File | Remove-Item
        }
        & dotnet test InsuranceMicroservices.slnx -m:1 --no-build --nologo --logger 'trx;LogFilePrefix=environment' --results-directory artifacts/tests 2>&1 | Tee-Object -FilePath artifacts/test-output.txt
        if ($LASTEXITCODE -ne 0) { throw 'Tests failed.' }
    }
} finally { Pop-Location }

