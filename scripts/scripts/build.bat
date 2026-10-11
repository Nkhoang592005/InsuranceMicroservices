@echo off
cd /d "%~dp0..\.."
dotnet build InsuranceMicroservices.slnx -m:1
if errorlevel 1 exit /b %errorlevel%
dotnet test InsuranceMicroservices.slnx --no-build
exit /b %errorlevel%
