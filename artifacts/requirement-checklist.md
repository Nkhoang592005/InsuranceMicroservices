# Đối chiếu yêu cầu bài thực hành số 4

Phạm vi: Phần 2 – Cài đặt môi trường, theo ảnh đề bài người dùng cung cấp. Task 1 yêu cầu tạo project, chưa viết code nghiệp vụ.

| Yêu cầu | Kết quả / bằng chứng |
|---|---|
| Tạo solution; mỗi microservice 3 project | `InsuranceMicroservices.slnx`: 9 service × API, implementation, test; thêm Gateway và Blazor, tổng 29 project |
| MediatR và đăng ký DI | 9 implementation có PackageReference và AddMediatR; test kiểm tra ISender qua DI |
| PostgreSQL >= 10 và tạo CSDL theo script | PostgreSQL 16.15; 4 CSDL payments, jobs, policy, pricing, owner lab_user; `database-verification.txt` |
| RabbitMQ | Có cấu hình image và thông tin kết nối trong infra.yml; chưa chạy container do Docker engine lỗi |
| Elasticsearch >= 6 | Image Elasticsearch 8.9.2 trong infra.yml; chưa chạy container do Docker engine lỗi |
| Docker, Docker Compose | Đã cài CLI/Desktop và cấu hình 2 stack; config hợp lệ; Desktop báo unable to start |
| Add eureka-server, postgres, scripts, Web, BlazorWasmClient, AgentPortalApiGateway | Đã có source và mục tương ứng trong solution |
| Build hệ thống và sửa lỗi | .NET, Vue, Eureka có log riêng; chạy lại bằng scripts/scripts/build-all.ps1 |
| Backup PostgreSQL để restore | 4 file custom .backup và 4 SQL; đã restore thử; log database-verification.txt, sql-restore-verification.txt |
| Ảnh kết quả build | build-result.png, ảnh cửa sổ hiển thị build-output.txt thật |
| GitHub và GitHub Desktop | Remote đã có; GitHub Desktop chưa tìm thấy ở vị trí cài thông thường; chưa xác nhận đăng nhập hoặc publish source |
| Mời giảng viên caotxuan@gmail.com | Chưa gửi lời mời; cần quyền quản lý repository |
| Nộp elearning | Chưa nộp; gói source và backup đã chuẩn bị trong artifacts |

Không coi cấu hình Compose hợp lệ là bằng chứng các container đã chạy. Các mục Docker runtime, GitHub Desktop, publish GitHub, quyền giảng viên và nộp elearning còn chưa hoàn tất.
