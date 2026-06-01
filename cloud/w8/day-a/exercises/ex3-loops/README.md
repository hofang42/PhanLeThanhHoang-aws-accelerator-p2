# Bài tập 3: Meta-arguments (`count` và `for_each`)

## 1. Đề bài
**Mục tiêu:** Thành thạo tự động hóa tạo nhiều tài nguyên.
- Tạo 3 EC2 instance bằng cách lặp qua danh sách môi trường: `dev`, `staging`, `prod`.
- Có thể dùng `count` hoặc `for_each`.
- Gắn tag `Name` linh hoạt dựa trên vòng lặp tương ứng.

## 2. Những gì đã thực hiện
- Đã thay đổi biến `envName` sang kiểu dữ liệu `map(string)` (trong `variables.tf`) chứa 3 môi trường: `{ dev = "dev", staging = "staging", prod = "prod" }`.
- Áp dụng thành công meta-argument `for_each = var.envName` vào `aws_instance` trong `main.tf`.
- Xử lý việc đặt tên máy ảo động bằng nội suy (interpolation): `Name = "ec2_loop_Server-${each.key}"`.
- Hiểu được sự khác biệt và ưu việt của `for_each` so với `count` khi quản lý danh sách tài nguyên, tránh lỗi "Invalid Index".
