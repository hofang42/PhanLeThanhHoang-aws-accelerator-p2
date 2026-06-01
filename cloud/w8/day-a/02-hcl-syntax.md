# HashiCorp Configuration Language (HCL) Syntax

## 1. Cấu trúc cơ bản
- **Blocks:** Là các thành phần chính như `resource`, `data`, `provider`, `variable`, chứa thông tin cấu hình bên trong cặp ngoặc nhọn `{}`.
- **Arguments:** Các cặp `key = value` nằm bên trong Block.
- **Identifiers:** Tên định danh của block hoặc resource, ví dụ trong `resource "aws_instance" "web" {}`, thì `"web"` chính là identifier.

## 2. Variables (Biến đầu vào)
Biến giúp tham số hóa cấu hình.
```hcl
variable "instance_type" {
  description = "Loại máy chủ EC2"
  type        = string
  default     = "t2.micro"
}
```
Truyền giá trị bằng file `terraform.tfvars`:
```hcl
instance_type = "t3.small"
```
Khi dùng biến trong code: `var.instance_type`.

## 3. Outputs (Biến đầu ra)
Dùng để in ra kết quả sau khi `terraform apply` thành công (ví dụ lấy IP Public của máy chủ vừa tạo).
```hcl
output "public_ip" {
  description = "IP của EC2 instance"
  value       = aws_instance.web.public_ip
}
```

## 4. Local Values
Dùng để gán các giá trị lặp lại nhiều lần vào một biến cục bộ, giúp code ngắn gọn và dễ đổi hơn.
```hcl
locals {
  common_tags = {
    Environment = "dev"
    Project     = "ecommerce"
  }
}

# Cách dùng: tags = local.common_tags
```

## 5. Tham chiếu (References)
Terraform tự hiểu dependency khi ta tham chiếu thuộc tính của resource này cho resource kia.
Ví dụ: Tạo Security Group xong, lấy ID truyền cho EC2.
```hcl
resource "aws_instance" "web" {
  ami                    = "ami-12345"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_web.id] # <-- Tham chiếu
}
```
