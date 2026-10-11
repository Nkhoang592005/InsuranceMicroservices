@echo off
cd /d "%~dp0..\.."
dotnet build InsuranceMicroservices.slnx -m:1
exit /b %errorlevel%
