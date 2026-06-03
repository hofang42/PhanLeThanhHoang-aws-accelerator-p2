# Bài tập 3: Thực hành Architecture Decision Record (ADR)

## Mục đích
Học cách ghi nhận lại quyết định về kiến trúc để đội ngũ dự án có chung sự hiểu biết và lịch sử các lựa chọn kỹ thuật.

## Các bước thực hiện

1. Mở terminal và di chuyển đến thư mục bài tập 3:
   ```bash
   cd cloud/w8/day-c/exercises/ex3-adr-practice
   ```
2. Mở file `0001-terraform-state-management.md`. Đây là một bản ADR mô tả quyết định chọn S3 + DynamoDB để quản lý state (thay vì Terraform Cloud hay Git).
3. Hãy đọc qua file để hiểu cấu trúc của một tài liệu ADR chuẩn (dựa trên format của Michael Nygard).
4. **Bài tập nhỏ**:
   - Tưởng tượng sếp của bạn đề xuất dùng **Terraform Cloud** (phiên bản miễn phí) thay vì tự quản lý bằng **S3 và DynamoDB** do nhóm thiếu người quản trị hạ tầng.
   - Hãy thử tạo một file ADR mới. Bạn có thể dùng lệnh copy để tạo file mới từ file cũ:
     ```bash
     cp 0001-terraform-state-management.md 0002-migrate-to-terraform-cloud.md
     ```
   - Sau đó mở file `0002-migrate-to-terraform-cloud.md` bằng IDE và cập nhật các thông tin sau:
     - **Title**: Chuyển sang Terraform Cloud
     - **Context** (Bối cảnh): Nhóm ít người, cần UI quản lý state trực quan, Terraform Cloud Free tier đủ dùng.
     - **Decision** (Quyết định): Sẽ chuyển sang sử dụng Terraform Cloud để quản lý state thay cho S3 & DynamoDB.
     - **Consequences** (Hệ quả): Phụ thuộc vào bên thứ 3 (HashiCorp), nhưng bù lại cấu hình nhanh hơn và có sẵn giao diện quản trị chuyên nghiệp.
