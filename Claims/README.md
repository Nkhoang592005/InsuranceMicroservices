# Yêu cầu bồi thường

Phần mở rộng dữ liệu demo, không phải một microservice .NET mới.

- `schema.sql`: schema `claims`, bảng `records`, khóa chính và ràng buộc dữ liệu.
- `seed.sql`: 5 bản ghi giả lập; chạy lại không ghi đè bản ghi đã tồn tại.
- `verify.sql`: kiểm tra đủ 5 mã dữ liệu mẫu.
- `sample.json`: cùng dữ liệu mẫu để tham khảo API/frontend.

Chạy từ thư mục gốc: `scripts/scripts/database-demo.ps1`. Script dùng CSDL riêng `lab_netmicro_demo`. Có thể chạy lần lượt ba file SQL bằng psql trong CSDL demo đã tạo.

Các cột có hậu tố `_code` liên kết logic với các module khác. Bộ dữ liệu dùng chung mã mẫu; script kiểm tra tổng kiểm tra các liên kết. Không có khóa ngoại xuyên service; các bảng demo này chưa kết nối vào backend hiện tại.

Dữ liệu hoàn toàn giả lập; địa chỉ email dùng miền `example.test`. Identity chỉ minh họa username/role, chưa thực hiện đăng nhập hay lưu mật khẩu.
