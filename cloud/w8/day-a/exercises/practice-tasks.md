# Bài tập thực hành Terraform (Day A)

Dưới đây là các bài tập giúp bạn làm quen với cú pháp HCL, cách tổ chức thư mục, làm việc với biến, vòng lặp, meta-arguments và viết modules trong Terraform.
Bạn hãy tạo các thư mục tương ứng cho từng bài tập bên trong thư mục `exercises` này để thực hành nhé.

*(Lưu ý: Bạn cần có tài khoản AWS và đã cấu hình AWS CLI `aws configure` thành công trên máy tính để thực hiện các bài tập này. Các bài tập sẽ sử dụng EC2 instance loại `t2.micro` thuộc Free Tier để không phát sinh chi phí lớn).*

---

## Bài tập 1: Làm quen với cú pháp và vòng đời (Workflow)
**Mục tiêu:** Hiểu cấu trúc file cơ bản và chạy được các lệnh `init`, `plan`, `apply`, `destroy` với provider AWS.

**Yêu cầu:**
1. Tạo thư mục `ex1-basics`.
2. Tạo file `main.tf` khai báo provider `aws` (region tùy chọn, ví dụ `ap-southeast-1`).
3. Định nghĩa một tài nguyên `aws_instance` để tạo một EC2 instance. Sử dụng AMI của Amazon Linux 2023 (bạn có thể tìm AMI ID mới nhất trên AWS Console, ví dụ `ami-0c55b159cbfafe1f0` đối với us-east-1) và `instance_type = "t2.micro"`.
4. Gắn thêm thẻ (tags) cho instance: `Name = "MyFirstEC2"`.
5. Chạy `terraform init`. Quan sát thư mục `.terraform` được tạo ra.
6. Chạy `terraform plan` để xem Terraform sẽ tạo ra những gì trên AWS.
7. Chạy `terraform apply` và lên AWS Console kiểm tra xem EC2 đã chạy chưa.
8. Mở file `terraform.tfstate` ra đọc thử xem Terraform lưu thông tin gì về EC2.
9. Đổi tên tag thành `Name = "MyUpdatedEC2"`, chạy lại `terraform apply` và quan sát hành vi của Terraform (update in-place).
10. Dọn dẹp: Chạy `terraform destroy` để xóa EC2, tránh mất phí.

---

## Bài tập 2: Kiểu dữ liệu, Biến (Variables) và Output
**Mục tiêu:** Phân chia thư mục đúng chuẩn, khai báo biến, dùng `.tfvars` và in giá trị ra màn hình.

**Yêu cầu:**
1. Tạo thư mục `ex2-variables`.
2. Tạo 4 file: `main.tf`, `variables.tf`, `outputs.tf` và `terraform.tfvars`.
3. Trong `variables.tf`, định nghĩa các biến sau:
   - `instance_type` (kiểu `string`, default là `"t2.micro"`)
   - `common_tags` (kiểu `map(string)`)
4. Trong `terraform.tfvars`, gán giá trị cho `common_tags` (ví dụ: `{ Environment = "Dev", Project = "Terraform-Practice" }`).
5. Trong `main.tf`, cấu hình `aws_instance` và sử dụng `var.instance_type` và `var.common_tags`.
6. Trong `outputs.tf`, in ra Public IP (`public_ip`) và Private IP (`private_ip`) của máy ảo vừa tạo.
7. Chạy `apply` và kiểm tra giá trị Output in ra console. Nhớ `destroy` sau khi làm xong.

---

## Bài tập 3: Meta-arguments (`count` và `for_each`)
**Mục tiêu:** Thành thạo tạo nhiều tài nguyên tự động.

**Yêu cầu:**
1. Tạo thư mục `ex3-loops`.
2. **Dùng `count`:** Tạo 3 EC2 instance bằng cách thêm tham số `count = 3` vào khối `aws_instance`. Đặt tên tag Name thành `Web-Server-0`, `Web-Server-1`, `Web-Server-2` dựa vào biến `count.index`.
3. **Dùng `for_each`:** Thay vì tạo bằng count, khai báo một biến danh sách môi trường `envs = ["dev", "staging", "prod"]`. 
   Chuyển đổi resource sang dùng `for_each = toset(var.envs)` để tạo 3 EC2, đặt tag Name lần lượt là `Server-dev`, `Server-staging`, `Server-prod`.
4. Apply để xem kết quả.
5. Thử thách: Thử xóa "staging" ra khỏi danh sách `envs` ở bước 3, chạy `terraform plan` để xem Terraform ứng xử thế nào so với khi dùng `count`. 
6. Đừng quên gõ `terraform destroy` khi hoàn thành.

---

## Bài tập 4: Expressions và Locals
**Mục tiêu:** Viết logic có điều kiện và sử dụng biến cục bộ.

**Yêu cầu:**
1. Tạo thư mục `ex4-expressions`.
2. Khai báo biến `environment` (nhận giá trị "dev" hoặc "prod").
3. Sử dụng **Toán tử điều kiện (Ternary operator)** để chọn `instance_type`: nếu `environment == "prod"` thì dùng `"t3.micro"`, ngược lại dùng `"t2.micro"`.
4. Sử dụng block `locals` để ghép chuỗi tạo ra một tên duy nhất: `server_name = "app-${var.environment}-ec2"`, sau đó dùng `local.server_name` làm tag Name cho EC2.
5. Dùng biểu thức vòng lặp `[for ...]` trong block `output` để in ra danh sách các tên thẻ tags dưới dạng in hoa.

---

## Bài tập 5: Tạo và gọi Module
**Mục tiêu:** Thực hành tái sử dụng code theo cấu trúc Module với AWS.

**Yêu cầu:**
1. Tạo thư mục `ex5-modules`.
2. Xây dựng cấu trúc thư mục sau:
   ```text
   ex5-modules/
     ├── modules/
     │   └── ec2-instance/
     │       ├── main.tf
     │       ├── variables.tf
     │       └── outputs.tf
     ├── main.tf
     └── outputs.tf
   ```
3. **Trong Child Module (`modules/ec2-instance`):** Viết logic tạo ra một `aws_instance` với tham số đầu vào (trong `variables.tf`) là `server_name` và `instance_type`. Output trả về `instance_id`.
4. **Trong Root Module (`ex5-modules/main.tf`):** Dùng block `module "app1" { ... }` và `module "app2" { ... }` để gọi module `ec2-instance` **2 lần**. Truyền biến để tạo ra 2 server khác nhau (ví dụ: 1 server tên "web-frontend" và 1 server tên "db-backend").
5. Chạy `terraform init` (để Terraform nhận diện local module) rồi chạy `terraform apply`. Lên AWS Console kiểm tra xem 2 instance đã chạy chưa. 
6. Kết thúc bài thực hành bằng `terraform destroy`.
