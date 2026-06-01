# Bài tập 2: Kiểu dữ liệu, Biến (Variables) và Output

## 1. Đề bài
**Mục tiêu:** Phân chia thư mục đúng chuẩn, khai báo biến, dùng `.tfvars` và in giá trị ra màn hình.
- Tạo các file chuẩn: `main.tf`, `variables.tf`, `outputs.tf` và `terraform.tfvars`.
- Định nghĩa biến `instance_type` (kiểu string) và `common_tags` (kiểu map).
- Gán giá trị biến thông qua file `terraform.tfvars`.
- Dùng `outputs.tf` để in ra địa chỉ IP của máy ảo sau khi khởi tạo.

## 2. Những gì đã thực hiện
- Đã chia tách code thành 4 file chuẩn theo mô hình dự án Terraform.
- Khai báo biến `common_tags` với kiểu dữ liệu `map(string)` trong `variables.tf`.
- Cung cấp dữ liệu thật (Project, Environment, Owner) thông qua file `terraform.tfvars`.
- Tham chiếu biến vào `main.tf` qua cú pháp `var.common_tags`.
- Cấu hình file `outputs.tf` để lấy được Public IP của EC2 sau khi tạo xong. Tự động hóa được quy trình truyền tham số mà không cần sửa code gốc.
