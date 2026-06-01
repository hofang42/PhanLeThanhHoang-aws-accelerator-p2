# Bài tập 1: Làm quen với cú pháp và vòng đời (Workflow)

## 1. Đề bài
**Mục tiêu:** Hiểu cấu trúc file cơ bản và chạy được các lệnh `init`, `plan`, `apply`, `destroy` với provider AWS.
- Tạo file `main.tf` khai báo provider `aws` (ví dụ `ap-southeast-1`).
- Định nghĩa tài nguyên `aws_instance` tạo EC2 với AMI Amazon Linux 2023 và `instance_type = "t3.micro"`.
- Gắn thẻ (tags) cho instance.
- Thực hành các lệnh CLI của Terraform để quan sát quá trình tạo và quản lý state.

## 2. Những gì đã thực hiện
- Đã tạo file `main.tf` định nghĩa `provider "aws"`.
- Khai báo resource `aws_instance.ec2_ex1` với cấu hình Free Tier `t3.micro` (do `t2.micro` không hỗ trợ tại region).
- Gắn thẻ `Name = "ec2_ex1_terraform"`.
- Đã chạy thành công các lệnh `terraform init`, `terraform plan`, `terraform apply` để tạo máy ảo và cuối cùng là `terraform destroy` để dọn dẹp hạ tầng an toàn.
