# Bài thực hành 4 – Cài đặt môi trường Microservices .NET

Đối chiếu PDF `Bai thuc hanh 4_Case study_Cong ty bao hiem_Cai dat 1.pdf` với sáu bộ source cung cấp: `AgentPortalApiGateway.rar`, `BlazorWasmClient.rar`, `eureka-server.rar`, `postgres.rar`, `scripts.rar`, `Web.rar`.

## Phạm vi bài

PDF yêu cầu tạo cấu trúc project, thêm MediatR, cài môi trường, đưa các bộ source vào solution, sửa lỗi build và nộp backup PostgreSQL cùng ảnh kết quả build. Task 1 ghi rõ **chỉ tạo tên project, chưa viết code nghiệp vụ**. Vì vậy các service hiện cung cấp `/health` để kiểm chứng khởi động; chức năng bán bảo hiểm, JWT, SignalR, RabbitMQ consumer, Elasticsearch indexing và tạo PDF chưa được triển khai. Giao diện được giữ từ bộ source gốc và build cùng các định nghĩa DTO còn thiếu.

## Cấu trúc

### Phần mở rộng dữ liệu demo

Repository có **27 thư mục ngoài cùng**: 9 thư mục ban đầu và 18 module dữ liệu bảo hiểm bổ sung. Không tính `.git` hoặc `.tools`. Các module mới xuất hiện trong solution dưới `DataModules` dưới dạng solution items; solution vẫn có 29 project .NET.

18 module: Customers, Agents, Products, Quotes, Contracts, Billing, Payments, Claims, Commissions, Renewals, Underwriting, Risk, Notifications, Reporting, Audit, Identity, Support, Workflow.

Mỗi module có `schema.sql`, `seed.sql`, `verify.sql`, `sample.json` và `README.md`. Tổng cộng 90 file module, 18 bảng và 90 bản ghi giả lập. Các khoản tiền dùng VND. Email dùng `example.test`; không có dữ liệu cá nhân thật. Dữ liệu mô tả 5 hồ sơ khách hàng, báo giá, hợp đồng, thanh toán và các hoạt động liên quan. Liên kết được kiểm tra bằng mã dùng chung giữa các module.

```powershell
& .\scripts\scripts\database-demo.ps1
& .\scripts\scripts\verify-demo-backups.ps1
```

Script tạo/nạp CSDL riêng `lab_netmicro_demo`, không thay đổi 4 CSDL bắt buộc. Tất cả schema và seed chạy trong một transaction; chạy lại giữ các bản ghi đã có, không nhân đôi dữ liệu mẫu. Script kiểm tra quan hệ, ngày hiệu lực, tiền thanh toán và công thức hoa hồng; kiểm tra số âm và ngày đảo bị ràng buộc từ chối.

Backup demo nằm tại `artifacts/backups/demo/lab_netmicro_demo.sql` và `.backup`. Script kiểm chứng restore vào hai CSDL mới có hậu tố ngẫu nhiên, rồi kiểm tra dữ liệu phục hồi mà không nạp lại seed. Có thể dùng `psql -d <database-moi> -v ON_ERROR_STOP=1 -f lab_netmicro_demo.sql` hoặc pgAdmin Restore với `.backup`.

Đây là phần mở rộng dữ liệu, chưa triển khai thêm 18 microservice hoặc kết nối các bảng mới vào frontend/backend. `Identity` chỉ chứa tên tài khoản và vai trò mẫu. Chạy `python scripts/scripts/generate-demo-modules.py` để tái tạo file module từ bộ fixture cố định; lệnh này ghi lại các file mẫu nên không chạy sau khi tự sửa chúng.

- `InsuranceMicroservices.slnx`: 29 project, gồm 9 service × 3 project, Gateway và Blazor.
- `src/<Service>/<Service>.Api`: thư viện định nghĩa giao tiếp/DTO (`net8.0`, dùng được bởi Blazor gốc và implementation .NET 10).
- `src/<Service>/<Service>`: ứng dụng ASP.NET Core `net10.0`, đăng ký MediatR và endpoint `/health`.
- `src/<Service>/<Service>.Test`: kiểm thử khởi động HTTP và phân giải MediatR qua DI.
- 9 service: Product, Pricing, Policy, PolicySearch, Payment, Document, Auth, Chat, Dashboard. Dashboard được thêm vì frontend gốc tham chiếu nó.
- `AgentPortalApiGateway/AgentPortalApiGateway`: Gateway Ocelot gốc trên .NET 8; Steeltoe cập nhật 3.4.0. JWT và các route gốc được giữ.
- `BlazorWasmClient/BlazorWasmClient`: frontend Blazor gốc trên .NET 8.
- `Web/Web`: frontend Vue gốc; dùng Dart Sass thay node-sass cũ.
- `postgres/postgres`: khởi tạo PostgreSQL và CSDL.
- `eureka-server/eureka-server`: Eureka Java/Gradle từ file RAR.
- `scripts/scripts`: build, Docker Compose, chạy service và backup/restore.

## Build và kiểm thử .NET

Cần .NET SDK 10. Chạy từ thư mục gốc:

```powershell
& .\scripts\scripts\build.ps1
```

Build toàn bộ source (.NET, 9 test, Eureka, Vue và kiểm tra cấu hình Compose):

```powershell
& .\scripts\scripts\build-all.ps1
```

Kết quả đã kiểm tra: build thành công, **0 warning, 0 error**; **9/9 kiểm thử đạt**. Bằng chứng: `artifacts/build-output.txt`, `artifacts/build-result.png`, `artifacts/tests/*.trx`. Ảnh là ảnh cửa sổ hiển thị log build thật, tạo bằng `capture-build.ps1`.

Chạy một service:

```powershell
& .\scripts\scripts\run-local.ps1 -Service ProductService
# Mở http://localhost:5030/health
```

| Service | Port local |
|---|---:|
| Product | 5030 |
| Pricing | 5040 |
| Policy | 5050 |
| PolicySearch | 5065 |
| Payment | 5070 |
| Document | 5080 |
| Auth | 6060 |
| Chat | 4099 |
| Dashboard | 5035 |
| Gateway | 8099 |

## PostgreSQL và backup nộp bài

Bốn CSDL bắt buộc theo `createdatabases.sql`: `lab_netmicro_payments`, `lab_netmicro_jobs`, `lab_netmicro_policy`, `lab_netmicro_pricing`. Chủ sở hữu là `lab_user`. Script chạy lại an toàn, không xóa dữ liệu. Các file `create_*_database.sql` bổ sung có sẵn được giữ làm phần mở rộng; PDF không yêu cầu các CSDL này.

Máy có PostgreSQL 16.15 tại `D:\postgresql-16.15-5-windows-x64-binaries\pgsql\bin`. PostgreSQL hiện có trên port 5432 được giữ nguyên. Để hoàn thành backup mà không cần tài khoản quản trị của instance đó, đã khởi tạo instance riêng trên **127.0.0.1:5434**, data trong `%TEMP%\insurance-bth4-postgres`. Instance riêng dùng trust chỉ trên loopback để kiểm chứng bài thực hành. Đây là instance kiểm tra cục bộ.

```powershell
& .\scripts\scripts\database.ps1 -Action create
& .\scripts\scripts\database.ps1 -Action backup
& .\scripts\scripts\database.ps1 -Action verify
```

`artifacts/backups/lab_netmicro_*.backup` là **backup PostgreSQL thật định dạng custom**, xuất bằng `pg_dump -Fc`. Bốn backup đã restore thử thành công vào CSDL mới có hậu tố `_restored`. Theo yêu cầu bổ sung, cũng đã xuất bốn `lab_netmicro_*.sql` bằng `pg_dump --format=plain` và restore thử vào bốn CSDL riêng có hậu tố `_sql_restored`. Gói SQL riêng: `artifacts/BaiThucHanh4-backup-sql.zip`.

CSDL là CSDL mới, chưa có bảng nghiệp vụ; điều này đúng với script gốc và phạm vi bài cài đặt. `existing_lab_netmicro_policy.backup` là bản sao bổ sung của CSDL policy có sẵn trên port 5432, không phải một trong bốn backup cần nộp.

Restore cả bốn SQL bằng tài khoản quản trị (giải nén gói SQL, mở terminal trong thư mục đó; đổi port/mật khẩu theo máy đích):

```powershell
psql -h localhost -p 5432 -U postgres -d postgres -v ON_ERROR_STOP=1 -f restore_all_databases.sql
```

File restore tổng dùng lệnh riêng của `psql` nên chạy bằng CLI `psql`, không dán vào Query Tool. Dùng bộ client PostgreSQL 16.15 hoặc mới hơn để hỗ trợ các lệnh an toàn `\restrict` trong dump. Có thể restore từng SQL vào một CSDL mới bằng `database.ps1 -Action restore -Format sql`.

Restore sang CSDL mới (script không ghi đè CSDL đã tồn tại):

```powershell
& .\scripts\scripts\database.ps1 -Action restore -Database lab_netmicro_policy -TargetDatabase lab_netmicro_policy_for_teacher -Port 5432 -Username postgres -PgBin 'C:\Program Files\PostgreSQL\16\bin'
```

Đặt `PGPASSWORD` trong terminal hoặc dùng cấu hình `.pgpass` trước khi kết nối instance yêu cầu mật khẩu. Có thể restore qua pgAdmin: tạo database mới → Restore → chọn `.backup`. Dùng PostgreSQL 16 hoặc mới hơn để restore các file này.

Khởi động lại/dừng instance kiểm chứng đã tạo:

```powershell
& 'D:\postgresql-16.15-5-windows-x64-binaries\pgsql\bin\pg_ctl.exe' -D "$env:TEMP\insurance-bth4-postgres" -l "$env:TEMP\insurance-bth4-postgres.log" -o '-p 5434 -h 127.0.0.1' -w start
& 'D:\postgresql-16.15-5-windows-x64-binaries\pgsql\bin\pg_ctl.exe' -D "$env:TEMP\insurance-bth4-postgres" -w stop
```

## Vue và Eureka

```powershell
Push-Location Web/Web
npm.cmd ci --no-audit --no-fund
$env:NODE_OPTIONS='--openssl-legacy-provider'
npm.cmd run build
Pop-Location
```

Vue gốc dùng webpack 4 nên cần tùy chọn OpenSSL trên Node mới. Log trong `artifacts/vue-build-output.txt`. Lệnh `npm run build` dùng `build.cjs`, chờ promise build của Vue CLI hoàn tất rồi thoát với mã tương ứng, tránh giữ tiến trình trên Node 24. Dockerfile dùng Node 22. Các biến API được mô tả trong `Web/Web/.env-example`; đây là frontend cho giai đoạn phát triển nghiệp vụ tiếp theo.

Eureka gốc dùng Gradle 6.8.2 và Java 8. JDK portable được tải vào `.tools` và giải nén thêm tại `%TEMP%/insurance-java8` để tránh lỗi đường dẫn có dấu của Java 8; không thay Java hệ thống. Chạy `scripts/scripts/build-eureka.ps1` để build bản sao source trong thư mục tạm ASCII. **Gradle build đã thành công**, log trong `artifacts/eureka-build-output.txt`, JAR trong `artifacts/eureka-server.jar`. Source Eureka không cung cấp test. ASP.NET Core Runtime 8 portable đặt trong `.tools/dotnet8` để chạy Gateway gốc. `.tools` không nằm trong gói source nộp bài.

Gateway đã khởi động và trả **HTTP 401** cho `GET /api/Products` không có JWT. Lần kiểm tra này chưa có Eureka chạy nên Gateway cũng ghi log lỗi kết nối registry; đây không phải kiểm thử nghiệp vụ đầy đủ. Sau đó Eureka đã khởi động bằng JAR vừa build và trang `http://localhost:8761/` trả **HTTP 200**. Các tiến trình kiểm chứng được dừng sau khi hoàn tất; xem log trong `artifacts/eureka-runtime-verification.txt`.

```powershell
Push-Location AgentPortalApiGateway/AgentPortalApiGateway
$env:ASPNETCORE_URLS='http://localhost:8099'
& ../../.tools/dotnet8/dotnet.exe bin/Debug/net8.0/AgentPortalApiGateway.dll
Pop-Location
```

## Docker

```powershell
docker compose -f scripts/scripts/infra.yml up -d --build
docker compose -f scripts/scripts/app.yml up -d --build
```

Đã sửa build context theo cấu trúc giải nén hai tầng, bổ sung Dockerfile cho implementation, dùng named volume, sửa RabbitMQ config và chia sẻ network `insurance-network`. PostgreSQL Docker dùng port host **5433** để tránh instance có sẵn trên 5432. Hai Compose đã qua `config --quiet`.

**Giới hạn trên máy hiện tại:** Docker Desktop báo `unable to start`; WSL báo kernel 5.10.16 và chưa có distribution. Vì vậy chưa chạy/kiểm thử container PostgreSQL, RabbitMQ, Elasticsearch, Eureka hay toàn bộ hệ thống bằng Docker. Cần khắc phục Docker Desktop/WSL rồi chạy hai lệnh trên. Các backend đang là cấu trúc ban đầu, nên các route nghiệp vụ ở Gateway chưa có handler tương ứng.

## Nộp bài

1. Source: repository đã cấu hình remote `https://github.com/Nkhoang592005/InsuranceMicroservices`. Những thay đổi trong lần làm này chưa được commit/push. Người sở hữu repository cần push source và mời giảng viên theo email trong PDF qua GitHub Settings → Collaborators. Chưa thực hiện gửi lời mời hoặc nộp elearning.
2. Backup: bốn file `artifacts/backups/lab_netmicro_*.backup` và/hoặc bốn `.sql`. Gói SQL riêng kèm lệnh restore: `artifacts/BaiThucHanh4-backup-sql.zip`.
3. Ảnh build: `artifacts/build-result.png`, kèm `artifacts/build-output.txt` để đối chiếu.
4. Gói source dự phòng: `artifacts/BaiThucHanh4-submission.zip` (không chứa `.git`, `.tools`, `node_modules`, `bin`, `obj` hoặc các bộ cài).

Sau khi thay đổi source, chạy lại build và tạo lại gói để bằng chứng khớp mã nguồn:

```powershell
& .\scripts\scripts\build.ps1
& .\scripts\scripts\capture-build.ps1
python .\scripts\scripts\prepare-submission.py
```

Script đóng gói kiểm tra đủ 9 kết quả test đạt, chữ ký backup PostgreSQL và các file bằng chứng; kiểm tra tính toàn vẹn ZIP rồi xuất `artifacts/submission-sha256.txt`. Script không sửa mã nguồn khi đóng gói. File `validation-summary.json` tổng hợp cả kết quả các lần kiểm chứng trước; Docker runtime vẫn chưa được xác nhận.
