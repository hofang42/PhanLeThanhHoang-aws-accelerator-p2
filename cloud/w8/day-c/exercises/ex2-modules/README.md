# Bài tập 2: Tái sử dụng Code với Terraform Modules

## Mục đích
Trong bài tập này, bạn sẽ học cách tách các block Terraform thành một Module độc lập (VPC Module) và tái sử dụng nó.
Thay vì cấu hình Subnet, VPC, Internet Gateway ở khắp mọi nơi, ta gói gọn chúng lại.

## Các bước thực hiện

### Bước 1: Tạo cấu trúc của Module
1. Mở terminal và di chuyển vào thư mục module VPC:
   ```bash
   cd cloud/w8/day-c/exercises/ex2-modules/modules/vpc
   ```
2. Tạo file `main.tf` trong thư mục này để định nghĩa tài nguyên AWS VPC và Subnet:
   ```hcl
   resource "aws_vpc" "main" {
     cidr_block           = var.vpc_cidr
     enable_dns_hostnames = true
     enable_dns_support   = true

     tags = {
       Name = "${var.env}-vpc"
     }
   }

   resource "aws_subnet" "main" {
     vpc_id     = aws_vpc.main.id
     cidr_block = cidrsubnet(var.vpc_cidr, 8, 1)

     tags = {
       Name = "${var.env}-subnet"
     }
   }
   ```
3. Tạo file `variables.tf` để định nghĩa các biến đầu vào của Module:
   ```hcl
   variable "vpc_cidr" {
     description = "CIDR block for the VPC"
     type        = string
     default     = "10.0.0.0/16"
   }

   variable "env" {
     description = "Environment name"
     type        = string
     default     = "dev"
   }
   ```
4. Tạo file `outputs.tf` chứa các giá trị trả về để nơi gọi module có thể lấy được thông tin:
   ```hcl
   output "vpc_id" {
     value = aws_vpc.main.id
   }

   output "subnet_id" {
     value = aws_subnet.main.id
   }
   ```

*Lưu ý: Bạn **không cần** chạy `terraform init` hay `apply` trong thư mục `modules/vpc`. Module chỉ là một khuôn mẫu (template).*

### Bước 2: Gọi Module từ App
1. Di chuyển vào thư mục `app` nơi chúng ta sẽ sử dụng module:
   ```bash
   cd ../../app
   ```
2. Tạo file `main.tf` và gọi module VPC mà bạn vừa viết. Cú pháp như sau:
   ```hcl
   provider "aws" {
     region = "us-east-1"
   }

   module "my_vpc" {
     source   = "../modules/vpc"
     vpc_cidr = "10.1.0.0/16"
     env      = "dev"
   }
   ```
   *Ở đây `source` trỏ đến thư mục chứa module. Chúng ta truyền vào các biến `vpc_cidr` và `env` tương ứng với những gì định nghĩa ở `variables.tf` của module.*

### Bước 3: Chạy và kiểm tra
1. Khởi tạo Terraform (để tải module về):
   ```bash
   terraform init
   ```
   *(Bạn sẽ thấy Terraform báo "Initializing modules...").*
2. Chạy lệnh plan để xem những thay đổi sắp thực hiện:
   ```bash
   terraform plan
   ```
   *Xem xét cách Terraform liệt kê việc sẽ tạo VPC và Subnet như thế nào (tên tài nguyên sẽ có tiền tố `module.my_vpc.`).*
3. Chạy lệnh apply để triển khai hạ tầng:
   ```bash
   terraform apply
   ```
   *Nhập `yes` khi được hỏi.*
4. Kiểm tra Console AWS để xác nhận VPC và Subnet đã được tạo thành công với tag Name là `dev-vpc` và `dev-subnet`.

### Dọn dẹp
1. Vẫn ở thư mục `app`, chạy lệnh sau để xóa hạ tầng đi nhé:
   ```bash
   terraform destroy
   ```
   *Nhập `yes` khi được hỏi.*
