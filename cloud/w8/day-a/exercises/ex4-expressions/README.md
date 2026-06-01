# Bài tập 4: Expressions và Locals

## 1. Đề bài
**Mục tiêu:** Viết logic có điều kiện, vòng lặp for và sử dụng biến cục bộ.
- Dùng `set(string)` cho danh sách môi trường `["dev", "prod"]`.
- Khai báo block `locals` làm tiền tố dùng chung.
- Dùng Toán tử điều kiện 3 ngôi (Ternary operator) để cấp máy `t3.micro` cho Prod, máy `t3.small` hoặc `t3.nano` cho Dev.
- Ghép chuỗi tạo Tag Name.
- In ra mảng ID máy ảo và tên môi trường viết hoa bằng vòng lặp `[for...]` trong `outputs.tf`.

## 2. Những gì đã thực hiện
- Đã tạo `locals { project_name = "ex4-expressions" }` và gọi ra bằng cú pháp `local.project_name`.
- Tích hợp logic cấp phát động vào vòng lặp `for_each`: `instance_type = each.key == "prod" ? "t3.micro" : "t3.small"`.
- Vượt qua rào cản báo lỗi 400 của tài khoản Academy/Free Tier (không hỗ trợ `t3.nano` mà phải đổi sang `t3.small`).
- Viết file `output.tf` khai thác thành công vòng lặp trong Terraform: `[for i in aws_instance.ec2_ex4 : i.id]` để bóc tách list ID từ map các máy ảo.
