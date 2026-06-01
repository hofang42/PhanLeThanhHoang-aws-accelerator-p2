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

## 6. Kiểu dữ liệu (Data Types)
Terraform hỗ trợ các kiểu dữ liệu chính:
- **Kiểu cơ sở (Primitive Types):** `string`, `number`, `bool`.
- **Kiểu phức hợp (Complex Types):**
  - `list`: Danh sách có thứ tự `["a", "b", "c"]`.
  - `set`: Danh sách các giá trị duy nhất (không trùng lặp).
  - `map`: Cặp key-value `{ env = "dev", project = "ecommerce" }`.
  - `object` và `tuple`: Cho phép định nghĩa một cấu trúc dữ liệu với nhiều kiểu khác nhau bên trong.

## 7. Resource & Data Source
- **Resource (`resource`):** Block dùng để ra lệnh cho Terraform **tạo mới và quản lý** một tài nguyên.
- **Data Source (`data`):** Block dùng để **đọc/truy vấn** thông tin của một tài nguyên ĐÃ TỒN TẠI (do làm thủ công hoặc từ một project Terraform khác). Terraform chỉ đọc mà không quản lý hay xóa tài nguyên đó.

## 8. Expressions (Biểu thức HCL)
HCL cho phép xử lý logic như lập trình:
- **Toán tử điều kiện (Ternary):** `condition ? true_val : false_val`. 
  - *Ví dụ:* `instance_type = var.env == "prod" ? "m5.large" : "t2.micro"`
- **Vòng lặp For:** Có thể duyệt qua List hoặc Map. 
  - *Ví dụ:* `[for s in var.names : upper(s)]` (trả về danh sách in hoa).
- **Splat Expression (`[*]`):** Cú pháp viết tắt để lấy mảng thuộc tính. 
  - *Ví dụ:* `aws_instance.web[*].public_ip` (Lấy tất cả IP Public của danh sách EC2 được tạo ra bằng `count`).

## 9. Meta-arguments & Lifecycle
Meta-arguments là các tham số đặc biệt do Terraform quản lý (không phải của riêng AWS Provider) dùng được trong bất kỳ resource nào:
- **`count`:** Chạy vòng lặp để tạo $N$ resource giống nhau. Truy cập qua `count.index`.
- **`for_each`:** Chạy vòng lặp dựa trên Map hoặc Set. Truy cập qua `each.key` và `each.value`. (Khuyên dùng hơn `count` vì khi xóa bớt phần tử ở giữa danh sách, Terraform sẽ không xóa nhầm các phần tử sau nó).
- **`depends_on`:** Chỉ định Terraform phải đợi resource A tạo xong mới được tạo resource B. (Chỉ dùng khi Terraform không tự suy luận được dependency).
- **`lifecycle`:** Điều khiển vòng đời của tài nguyên.
  - `create_before_destroy = true`: (Khuyên dùng khi đổi cấu hình Load Balancer/ASG) Tạo tài nguyên mới trước rồi mới xóa cái cũ, giúp zero-downtime.
  - `prevent_destroy = true`: Chặn gõ lệnh phá hủy resource (rất quan trọng với Database).
  - `ignore_changes = [tags]`: Nếu ai đó sửa Tags bằng tay trên AWS, gõ `terraform apply` sẽ bỏ qua sự khác biệt này và không ghi đè lại.
