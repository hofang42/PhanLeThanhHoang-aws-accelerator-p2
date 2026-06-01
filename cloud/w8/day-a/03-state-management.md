# State Management trong Terraform

## 1. File `.tfstate` là gì?
File `.tfstate` là bộ nhớ cục bộ (dạng JSON) của Terraform để lưu lại trạng thái thực tế của các tài nguyên đã tạo. Terraform dựa vào file này để biết tài nguyên nào đang tồn tại, thuộc tính ra sao, từ đó so sánh với code (`.tf`) để quyết định tạo mới, cập nhật hay xóa ở lần `apply` tiếp theo.

## 2. Tại sao KHÔNG nên lưu State ở Local?
- **Làm việc nhóm:** Nếu nhiều người cùng thao tác, file `terraform.tfstate` ở máy cá nhân sẽ gây bất đồng bộ, người này không biết hạ tầng của người kia tạo.
- **Rủi ro mất dữ liệu:** Lỡ tay xóa file hoặc hỏng máy là mất thông tin toàn bộ hạ tầng đã tạo.
- **Bảo mật:** File State chứa toàn bộ thông tin nhạy cảm (như mật khẩu DB, access keys) ở dạng plain text. Không bao giờ được commit file này lên Git (nên đã đưa vào `.gitignore`).

## 3. Remote State
Để làm việc nhóm, State cần được lưu trữ ở một kho chung an toàn, ví dụ như **AWS S3 Bucket**, Terraform Cloud, hoặc GCS.
```hcl
terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket"
    key    = "dev/network/terraform.tfstate"
    region = "ap-southeast-1"
  }
}
```

## 4. State Locking
Khi nhiều người cùng gõ `terraform apply` lúc, có nguy cơ ghi đè làm hỏng State. 
Với AWS, Terraform dùng **DynamoDB Table** để Lock State. Người đến trước sẽ giữ "khóa", người đến sau phải đợi người trước apply xong mới được thực thi.

## 5. Các lệnh xử lý State
- `terraform state list`: Liệt kê tất cả tài nguyên đang lưu trong state.
- `terraform state show <resource>`: Xem chi tiết cấu hình của 1 tài nguyên trong state.
- `terraform state rm <resource>`: Xóa tài nguyên khỏi state (Terraform sẽ ngừng quản lý nó, nhưng không xóa tài nguyên trên Cloud).
- `terraform state mv`: Đổi tên/chuyển tài nguyên trong state (rất hữu ích khi refactor code).
