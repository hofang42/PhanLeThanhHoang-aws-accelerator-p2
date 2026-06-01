# Terraform Best Practices

## 1. Tổ chức thư mục (Directory Structure)
Đối với dự án lớn, không nên bỏ tất cả vào 1 file `main.tf`. Nên tách thư mục theo môi trường và module.
Ví dụ:
```
.
├── modules/
│   ├── network/
│   ├── database/
│   └── web-app/
└── environments/
    ├── dev/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── backend.tf
    ├── staging/
    └── production/
```
Cách này giúp tách biệt State của các môi trường (Dev không đụng chạm đến Prod), giảm blast radius (phạm vi ảnh hưởng) nếu có lỗi xảy ra.

## 2. Quản lý State an toàn
- **Sử dụng Remote Backend:** Không bao giờ lưu State cục bộ. Nên dùng S3.
- **Bật State Locking:** Đảm bảo sử dụng khóa State (ví dụ DynamoDB) để tránh xung đột khi làm việc nhóm.
- **Bảo mật State:** State file chứa plaintext data (cả secret/password). Do đó S3 Bucket lưu State phải chặn public access, mã hóa KMS và hạn chế quyền IAM chặt chẽ.

## 3. Coding Standard & Workflow
- **`terraform fmt`:** Luôn format code tự động trước khi commit để chuẩn hóa format.
- **`terraform validate`:** Kiểm tra cú pháp trước khi chạy plan.
- **Sử dụng Modules:** Tái sử dụng code thay vì copy-paste (DRY).
- **Hardcode:** Tránh hardcode các giá trị như ID subnet, ID AMI. Hãy sử dụng variables hoặc `data` sources để tra cứu động (ví dụ dùng Data AWS AMI để lấy ID AMI mới nhất thay vì gõ cứng).

## 4. Bảo mật (Security)

### Quản lý Secret an toàn
- **Không bao giờ push Secret lên Git:** Các file như `terraform.tfvars` hay `*.auto.tfvars` thường chứa thông tin nhạy cảm (như mật khẩu DB, API keys). Phải luôn đảm bảo chúng được liệt kê trong `.gitignore`.
- **Không hardcode credentials:** Không ghi cứng Access Key / Secret Key của AWS vào file `provider.tf`. Hãy sử dụng Environment Variables (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`), file config của AWS CLI (`~/.aws/credentials`), hoặc IAM Roles.

### Sử dụng AWS Secrets Manager / Systems Manager Parameter Store
Thay vì định nghĩa trực tiếp mật khẩu vào code Terraform, hãy lưu chúng trên các dịch vụ quản lý secret của AWS, sau đó dùng block `data` để Terraform tự động kéo giá trị này về lúc chạy `apply`.

**Ví dụ đọc secret từ AWS Systems Manager Parameter Store:**
```hcl
# Kéo giá trị mật khẩu từ Parameter Store
data "aws_ssm_parameter" "db_password" {
  name            = "/production/database/password"
  with_decryption = true
}

# Tạo DB Instance và dùng mật khẩu vừa kéo về
resource "aws_db_instance" "default" {
  # ... các thông số khác ...
  password = data.aws_ssm_parameter.db_password.value
}
```

> **Lưu ý quan trọng:** Mặc dù cách này giúp code của bạn không lộ mật khẩu, nhưng giá trị secret **VẪN SẼ NẰM TRONG file `.tfstate`** dưới dạng plain text. Vì thế, việc bảo vệ an toàn cho file State (Remote Backend, giới hạn phân quyền IAM, mã hóa S3 KMS) là bắt buộc.

- Sử dụng các tool check lỗi bảo mật mã nguồn IaC như `tfsec` hoặc `checkov`.
