# Bài tập 1: Cấu hình Remote State với S3 và DynamoDB Lock

## Mục đích
Trong bài này, bạn sẽ:
1. Tạo một S3 bucket để lưu trữ state file (`terraform.tfstate`).
2. Tạo một DynamoDB table để hỗ trợ việc Lock state file (chống conflict khi nhiều người cùng thao tác).
3. Cấu hình Terraform Backend để sử dụng hai tài nguyên vừa tạo.

## Các bước thực hiện

### Bước 1: Tạo hạ tầng Backend (Thư mục `setup-backend`)
Do S3 và DynamoDB cần phải tồn tại *trước khi* Terraform cấu hình backend, ta phải tạo chúng trước (lúc này state của chúng sẽ lưu ở local).

1. Mở terminal và di chuyển đến thư mục `setup-backend`:
   ```bash
   cd cloud/w8/day-c/exercises/ex1-remote-state/setup-backend
   ```
2. Tạo file `main.tf` trong thư mục `setup-backend` và thêm nội dung sau để tạo S3 Bucket và DynamoDB Table:
   ```hcl
   provider "aws" {
     region = "us-east-1"
   }

   resource "random_id" "bucket_suffix" {
     byte_length = 4
   }

   resource "aws_s3_bucket" "terraform_state" {
     bucket        = "my-terraform-state-bucket-${random_id.bucket_suffix.hex}"
     force_destroy = true # Cho phép xóa bucket kể cả khi có file bên trong (để tiện dọn dẹp)
   }

   resource "aws_s3_bucket_versioning" "enabled" {
     bucket = aws_s3_bucket.terraform_state.id
     versioning_configuration {
       status = "Enabled"
     }
   }

   resource "aws_dynamodb_table" "terraform_locks" {
     name         = "terraform-state-locks"
     billing_mode = "PAY_PER_REQUEST"
     hash_key     = "LockID"

     attribute {
       name = "LockID"
       type = "S"
     }
   }

   output "s3_bucket_name" {
     value = aws_s3_bucket.terraform_state.bucket
   }
   ```
3. Khởi tạo Terraform:
   ```bash
   terraform init
   ```
4. Chạy lệnh để triển khai hạ tầng backend. Nhập `yes` khi được hỏi:
   ```bash
   terraform apply
   ```
   *Lưu ý: Hãy ghi lại tên của S3 bucket được in ra trên màn hình (outputs) sau khi apply thành công.*

### Bước 2: Cấu hình ứng dụng sử dụng Remote Backend (Thư mục `app`)
1. Di chuyển vào thư mục `app`:
   ```bash
   cd ../app
   ```
2. Tạo file `main.tf` trong thư mục `app` và thêm nội dung sau. Hãy nhớ thay thế `<TÊN_BUCKET_CỦA_BẠN>` bằng tên bucket bạn vừa nhận được ở Bước 1:
   ```hcl
   terraform {
     backend "s3" {
       bucket         = "<TÊN_BUCKET_CỦA_BẠN>" # Thay thế bằng tên S3 bucket
       key            = "app/terraform.tfstate"
       region         = "us-east-1"
       dynamodb_table = "terraform-state-locks"
       encrypt        = true
     }
   }

   provider "aws" {
     region = "us-east-1"
   }

   resource "aws_instance" "app_server" {
     ami           = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS us-east-1
     instance_type = "t2.micro"

     tags = {
       Name = "RemoteStateAppServer"
     }
   }
   ```
3. Khởi tạo lại Terraform để nhận diện backend S3 và thiết lập kết nối:
   ```bash
   terraform init
   ```
   *Nhập `yes` nếu Terraform hỏi bạn có muốn copy state hiện tại sang S3 không.*
4. Chạy lệnh apply để tạo một tài nguyên EC2 đơn giản:
   ```bash
   terraform apply
   ```
5. Sau khi `apply` thành công, hãy vào AWS Console (S3 và DynamoDB) để kiểm tra xem file state đã được lưu trên S3 chưa.

### Bước 3: Thử nghiệm State Lock
1. Thử sửa file `app/main.tf`, ví dụ đổi giá trị tag của EC2 instance thành `"RemoteStateAppServer-Updated"`.
2. Chạy lệnh apply nhưng khoan gõ `yes`:
   ```bash
   terraform apply
   ```
3. Mở một terminal mới, di chuyển đến thư mục `app`:
   ```bash
   cd cloud/w8/day-c/exercises/ex1-remote-state/app
   ```
   Thử chạy lại lệnh apply ở terminal thứ 2 này:
   ```bash
   terraform apply
   ```
   Bạn sẽ thấy báo lỗi `Error acquiring the state lock` — chứng tỏ DynamoDB Lock đang hoạt động hiệu quả!
4. Quay lại terminal 1 và hủy lệnh (nhấn `Ctrl + C`).

### Dọn dẹp (Lưu ý quan trọng)
1. Trong thư mục `app`, chạy lệnh sau để xóa tài nguyên EC2:
   ```bash
   terraform destroy
   ```
2. Mở file `app/main.tf`, xóa (hoặc comment) block `backend "s3"`. Chạy lệnh sau để đưa state về lại local:
   ```bash
   terraform init -migrate-state
   ```
   *Lưu ý: Bạn phải làm bước này để dọn dẹp state trên S3. Bạn không thể xóa S3 bucket nếu nó vẫn đang chứa `terraform.tfstate`.*
3. Di chuyển lại sang thư mục `setup-backend`:
   ```bash
   cd ../setup-backend
   ```
4. Chạy lệnh để xóa S3 Bucket và DynamoDB Table:
   ```bash
   terraform destroy
   ```
