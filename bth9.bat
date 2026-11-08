@echo off
chcp 65001 > nul
title HE THONG MICROSERVICES - BAI THUC HANH SO 9
color 0B

:MENU
cls
echo ===============================================================================
echo          HE THONG MICROSERVICES - BAI THUC HANH SO 9 (CASE STUDY BAO HIEM)
echo ===============================================================================
echo.
echo   [1] KHOI CHAY DEMO 2 CHUC NANG (ProductService & PolicyService)
echo       - Tu dong bat service Product (Cong 5030) va Policy (Cong 5050)
echo       - Tu dong mo trinh duyet Swagger UI de quay video minh chung
echo.
echo   [2] CHAY KIEM THU TU DONG (UNIT TEST - PolicyService.Test)
echo       - Kiem tra 8 unit test cua microservice PolicyService
echo.
echo   [3] KHOI CHAY TOAN BO HE THONG BANG DOCKER COMPOSE
echo       - Khoi dong Ha tang: Eureka, PostgreSQL, RabbitMQ, ElasticSearch
echo       - Khoi dong Microservices & Giao dien Web (VueJS)
echo.
echo   [4] MO THU MUC DU AN TRONG FILE EXPLORER
echo.
echo   [0] THOAT
echo ===============================================================================
set /p opt="Nhap lua chon cua ban (0-4) va nhan Enter [Mac dinh: 1]: "

if "%opt%"=="" set opt=1
if "%opt%"=="1" goto RUN_DEMO
if "%opt%"=="2" goto RUN_TEST
if "%opt%"=="3" goto RUN_DOCKER
if "%opt%"=="4" goto OPEN_FOLDER
if "%opt%"=="0" goto EXIT
goto MENU

:RUN_DEMO
cls
echo ===============================================================================
echo   DANG KHOI CHAY CAC SERVICE DE QUAY VIDEO DEMO...
echo ===============================================================================
echo.
echo 1. Dang mo ProductService (Cong 5030)...
start "ProductService [Port 5030]" cmd /k "title ProductService [Port 5030] && cd /d \"d:\kiến trúc và thiết kế phần mềm\thực hành\bth4\" && set ASPNETCORE_ENVIRONMENT=Development && dotnet run --project \"src/ProductService/ProductService/ProductService.csproj\" --urls \"http://localhost:5030\""

echo 2. Dang mo PolicyService (Cong 5050)...
start "PolicyService [Port 5050]" cmd /k "title PolicyService [Port 5050] && cd /d \"d:\kiến trúc và thiết kế phần mềm\thực hành\bth4\" && set ASPNETCORE_ENVIRONMENT=Development && dotnet run --project \"src/PolicyService/PolicyService/PolicyService.csproj\" --urls \"http://localhost:5050\""

echo 3. Dang mo BlazorWasmClient (Giao dien Portal Cong 5081)...
start "BlazorWasmClient [Port 5081]" cmd /k "title BlazorWasmClient [Port 5081] && cd /d \"d:\kiến trúc và thiết kế phần mềm\thực hành\bth4\" && dotnet run --project \"BlazorWasmClient/BlazorWasmClient/BlazorWasmClient.csproj\" --urls \"http://localhost:5081\""

echo.
echo Dang cho cac service khoi dong (khoang 7 giay)...
timeout /t 7 /nobreak > nul

echo 4. Dang mo trinh duyet...
start http://localhost:5081
start http://localhost:5030/swagger
start http://localhost:5050/swagger

echo.
echo ===============================================================================
echo DA KHOI CHAY XONG!
echo Ban co the bat dau quay video man hinh tren 2 tab trinh duyet vua mo:
echo   - Tab 1: ProductService (GET /api/Products de xem danh sach san pham)
echo   - Tab 2: PolicyService (POST /api/Offer de tao bao gia, POST /api/Policy de phat hanh hop dong)
echo ===============================================================================
echo.
pause
goto MENU

:RUN_TEST
cls
echo ===============================================================================
echo   DANG CHAY UNIT TEST CHO POLICY SERVICE (TASK #1)...
echo ===============================================================================
echo.
cd /d "d:\kiến trúc và thiết kế phần mềm\thực hành\bth4"
dotnet test "src/PolicyService/PolicyService.Test/PolicyService.Test.csproj"
echo.
echo ===============================================================================
pause
goto MENU

:RUN_DOCKER
cls
echo ===============================================================================
echo   DANG KHOI DONG HE THONG BANG DOCKER COMPOSE...
echo ===============================================================================
echo.
cd /d "d:\kiến trúc và thiết kế phần mềm\thực hành\bth4"

echo 1. Kiem tra Docker...
docker info > nul 2>&1
if %errorlevel% neq 0 (
    echo Docker chua chay! Dang khoi dong Docker Desktop...
    if exist "C:\Users\HP\AppData\Local\Programs\DockerDesktop\Docker Desktop.exe" (
        start "" "C:\Users\HP\AppData\Local\Programs\DockerDesktop\Docker Desktop.exe"
    )
    echo Vui long doi Docker Desktop khoi dong hoan tat roi thu lai.
    pause
    goto MENU
)

echo 2. Khoi dong ha tang (Eureka, Postgres, RabbitMQ, ElasticSearch)...
docker compose -f scripts/scripts/infra.yml up -d

echo 3. Khoi dong ung dung & microservices...
docker compose -f scripts/scripts/app.yml up -d

echo.
echo Mo Dashboard cac dich vu:
start http://localhost:8080
start http://localhost:8761
start http://localhost:15672

echo Da khoi chay Docker thanh cong!
pause
goto MENU

:OPEN_FOLDER
explorer "d:\kiến trúc và thiết kế phần mềm\thực hành\bth4"
goto MENU

:EXIT
exit
