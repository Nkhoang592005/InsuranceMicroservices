param([string]$JavaHome = '', [switch]$SkipTests)
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '../..')).Path
if (!$JavaHome) {
    $JavaHome = (Get-ChildItem -LiteralPath "$env:TEMP/insurance-java8" -Directory -Filter 'jdk8*' | Select-Object -First 1).FullName
}
if (!(Test-Path -LiteralPath (Join-Path $JavaHome 'bin/java.exe'))) { throw 'Provide -JavaHome pointing to a JDK 8 directory without accents.' }
$env:JAVA_HOME = $JavaHome
# Legacy Java 8 launchers fail on some Windows Unicode paths; build a copy under TEMP.
$scratch = Join-Path $env:TEMP ('insurance-eureka-build-' + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Force -Path $scratch | Out-Null
$source = Join-Path $root 'eureka-server/eureka-server'
foreach ($item in @('build.gradle','settings.gradle','gradle','src')) {
    Copy-Item -LiteralPath (Join-Path $source $item) -Destination $scratch -Recurse -Force
}
Push-Location -LiteralPath $scratch
try {
    $gradleArgs = @('-classpath', 'gradle/wrapper/gradle-wrapper.jar', 'org.gradle.wrapper.GradleWrapperMain', 'build', '--no-daemon', '--console=plain')
    if ($SkipTests) { $gradleArgs += @('-x','test') }
    & (Join-Path $JavaHome 'bin/java.exe') @gradleArgs 2>&1 | Tee-Object -FilePath (Join-Path $root 'artifacts/eureka-build-output.txt')
    if ($LASTEXITCODE -ne 0) { throw 'Eureka build failed.' }
    Copy-Item -LiteralPath (Join-Path $scratch 'build/libs/eureka-server-0.0.1-SNAPSHOT.jar') -Destination (Join-Path $root 'artifacts/eureka-server.jar') -Force
} finally { Pop-Location }
