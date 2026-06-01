# Bài tập 5: Tạo và gọi Module

## 1. Đề bài
**Mục tiêu:** Thực hành tái sử dụng code theo cấu trúc Module với AWS.
- Xây dựng Child Module `ec2-instance` có chứa `main.tf`, `variables.tf`, `output.tf`.
- Đóng gói logic tạo EC2 vào Child Module.
- Dùng Root Module (`main.tf` ở ngoài cùng) để gọi block `module` 2 lần nhằm tạo ra 2 máy chủ khác nhau (frontend và backend).
- Lấy output từ Child module đẩy ngược lên màn hình console qua Root module.

## 2. Những gì đã thực hiện
- Tổ chức thành công thư mục chuẩn: `modules/ec2-instance`.
- Định nghĩa biến đầu vào (Tham số/Arguments) ở Child Module (`server_name`, `instance_type`).
- Chuyển block `provider "aws"` ra Root Module để tuân thủ Best Practice (Child Module tự động kế thừa).
- Dùng `module "app1"` và `module "app2"` tái sử dụng logic (hàm) một cách hoàn hảo.
- Xuất được `instance_id` từ Child Module (`value = aws_instance.ec2_module.id`) và khai báo lại `outputs.tf` ở Root Module để in kết quả ra terminal.
