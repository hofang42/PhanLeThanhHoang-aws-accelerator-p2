# Ngày C: Terraform Nâng Cao (State Management, Modules, Best Practices & ADR)

## Mục Tiêu Bài Học
- Hiểu và cấu hình được **Remote State Storage** bằng AWS S3.
- Cấu hình **State Locking** với Amazon DynamoDB để làm việc nhóm an toàn.
- Biết cách tổ chức và tái sử dụng code với **Terraform Modules**.
- Nắm vững các **Best Practices** khi làm việc với Terraform trong dự án thực tế.
- Viết và áp dụng **Architecture Decision Records (ADR)** trong thiết kế hạ tầng.

---

## 1. State Management (S3 + DynamoDB Lock)
Theo mặc định, Terraform lưu trữ state cục bộ trong file `terraform.tfstate`. Điều này không phù hợp khi làm việc nhóm hoặc chạy qua CI/CD vì:
- Rủi ro mất state nếu máy cá nhân hỏng hoặc file bị xóa nhầm.
- Xung đột state (Race Condition) khi nhiều người cùng chạy `terraform apply`.
- Lộ thông tin nhạy cảm (secrets, passwords) trong file text thông thường.

**Giải pháp chuẩn doanh nghiệp**: Sử dụng **Remote Backend** với Amazon S3 để lưu state và **DynamoDB** để khóa (lock) state.

- **S3 Bucket**: Đóng vai trò là nơi lưu trữ state an toàn. (Lưu ý: Luôn bật Versioning để có thể rollback state nếu cần).
- **DynamoDB Table**: Cung cấp cơ chế khóa (state locking) thông qua Partition Key là `LockID`. Khi một người đang `apply`, Terraform sẽ ghi một record vào bảng này. Những người khác chạy `apply` cùng lúc sẽ bị từ chối cho tới khi lệnh đầu tiên hoàn tất.

---

## 2. Terraform Modules
Modules là các thành phần độc lập (container) chứa nhiều tài nguyên được nhóm lại với nhau để phục vụ một chức năng chung.
- Giúp tổ chức code Terraform gọn gàng, dễ đọc.
- Áp dụng nguyên tắc DRY (Don't Repeat Yourself), dễ dàng tái sử dụng.
- Dễ dàng chia sẻ các mẫu hạ tầng chuẩn (Standardized Infrastructure) trong team.

**Cấu trúc chuẩn của một Module cơ bản:**
```text
my-vpc-module/
├── main.tf       # Nơi định nghĩa các resources
├── variables.tf  # Input parameters của module
└── outputs.tf    # Output attributes trả về sau khi tạo xong
```

---

## 3. Terraform Best Practices
Để dự án dễ dàng mở rộng và bảo trì, cần tuân thủ các quy tắc sau:
- **Bảo mật State**: Không bao giờ commit file `.tfstate` hay `.tfvars` chứa secret lên Git. Phải đưa vào `.gitignore`.
- **Modularize**: Hạn chế việc gom tất cả mọi thứ vào một file `main.tf` khổng lồ. Hãy chia nhỏ thành các modules hoặc file theo logic (ví dụ `vpc.tf`, `ec2.tf`, `rds.tf`).
- **Naming Conventions**: 
  - Đặt tên resource bằng snake_case (VD: `aws_instance.web_server`).
  - Hạn chế sử dụng tên có tiền tố thừa thãi như `aws_instance.aws_web_server`.
- **Phân tách môi trường (Environments)**:
  - Nếu hạ tầng các môi trường (Dev, Staging, Prod) giống nhau phần lớn, có thể dùng **Terraform Workspaces**.
  - Nếu hạ tầng phức tạp, nên tách thư mục vật lý (vd: `envs/dev/`, `envs/prod/`).
- **Sử dụng Variables và tfvars**: Không hard-code các giá trị (như AMI ID, Instance Type) vào `main.tf`.

---

## 4. Architecture Decision Records (ADR)
ADR (Bản ghi Quyết định Kiến trúc) là tài liệu ngắn gọn gọn ghi nhận lại các quyết định thiết kế/kiến trúc quan trọng, kèm theo bối cảnh (context) và lý do dẫn đến quyết định đó. ADR giúp cho những người vào dự án sau (hoặc chính bạn vài tháng sau) hiểu tại sao lại làm như vậy thay vì cách khác.

**Cấu trúc một file ADR chuẩn (Markdown):**
- **Title**: Tên quyết định (Ví dụ: `1. Sử dụng S3 và DynamoDB cho Terraform Backend`).
- **Status**: Trạng thái hiện tại (Proposed, Accepted, Rejected, Superseded).
- **Context**: Vấn đề gặp phải hoặc bối cảnh dẫn đến việc phải ra quyết định.
- **Decision**: Quyết định được chọn.
- **Consequences**: Hệ quả (cả mặt tích cực lẫn tiêu cực/đánh đổi).

---

## 🚀 Hướng Dẫn Thực Hành
Trong thư mục `exercises`, bạn sẽ làm lần lượt các bài tập thực hành theo thứ tự:

1. **`ex1-remote-state`**: Cấu hình tự động tạo AWS S3 và DynamoDB, sau đó migrate local state lên AWS.
2. **`ex2-modules`**: Tạo một module VPC riêng để tái sử dụng và gọi nó từ một môi trường app.
3. **`ex3-adr-practice`**: Thực hành đọc và viết tài liệu ADR cho quyết định kiến trúc (chọn loại State backend).
