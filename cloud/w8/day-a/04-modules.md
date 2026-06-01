# Terraform Modules

## 1. Khái niệm Module
Module là một thư mục chứa một hoặc nhiều file Terraform (`.tf`), được dùng để nhóm các tài nguyên lại với nhau thành một đơn vị logic.
Giống như function trong lập trình, module cho phép chúng ta đóng gói code, tái sử dụng (DRY) và tránh việc viết đi viết lại cấu hình cho hạ tầng tương tự nhau (như tạo nhiều VPC cho nhiều môi trường).

## 2. Cấu trúc một Module cơ bản
Thường bao gồm các file:
- `main.tf` (Code logic chính, nơi khai báo các resource)
- `variables.tf` (Khai báo biến đầu vào - input)
- `outputs.tf` (Định nghĩa kết quả trả về - output)

## 3. Root Module vs Child Module
- **Root Module:** Thư mục hiện tại mà bạn đang chạy lệnh `terraform apply`. Nó là entrypoint của cấu trúc hạ tầng.
- **Child Module:** Là các module được Root Module (hoặc một module khác) gọi bằng block `module`. Child module nhận inputs từ block gọi nó và trả ra outputs.

## 4. Cách gọi (sử dụng) một Module
Bạn dùng block `module` để gọi 1 module khác.
**Ví dụ gọi một Local Module:**
```hcl
module "my_vpc" {
  source = "./modules/vpc" # Đường dẫn tới thư mục chứa module

  # Truyền các biến đầu vào
  cidr_block = "10.0.0.0/16"
  env_name   = "production"
}
```

**Ví dụ gọi một Module từ Terraform Registry (Public):**
```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-1a", "ap-southeast-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
}
```
Mỗi khi thêm/sửa module, cần chạy lại `terraform init` để tải code của module về.
