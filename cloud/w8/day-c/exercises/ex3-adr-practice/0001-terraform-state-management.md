# 1. Sử dụng AWS S3 và DynamoDB cho Terraform State Management

Date: 2026-06-02

## Status
**Accepted**

## Context
Dự án của chúng ta đang sử dụng Terraform để triển khai hạ tầng trên AWS. Hiện tại, chúng ta đang bắt đầu làm việc nhóm với 3 kỹ sư DevOps. File `terraform.tfstate` mặc định được sinh ra ở máy cá nhân (Local State), dẫn đến các vấn đề sau:
- Khi một kỹ sư chạy `terraform apply`, họ không có state mới nhất từ kỹ sư khác.
- Rủi ro mất mát dữ liệu hạ tầng nếu ổ cứng của một kỹ sư bị hỏng.
- Nếu hai kỹ sư cùng chạy lệnh cấu hình hạ tầng cùng một lúc (Race Condition), hạ tầng AWS có thể bị lỗi, trùng lặp hoặc mâu thuẫn.

Chúng ta cần một cơ chế lưu trữ tập trung (Remote State) và cơ chế khóa (State Lock).
Các lựa chọn được xem xét:
1. **Terraform Cloud (TFC)**: Dịch vụ SaaS, dễ dùng nhưng bị giới hạn về tính năng ở bản Free.
2. **Git**: Lưu state trên Git. Gây lộ lọt secrets vì file state có dạng plain-text.
3. **AWS S3 + DynamoDB**: Sử dụng luôn hệ sinh thái AWS hiện có để lưu trữ.

## Decision
Chúng tôi quyết định sử dụng **Amazon S3** để làm Remote Backend cho Terraform và **Amazon DynamoDB** để xử lý State Locking.

- **S3 Bucket** sẽ được cấu hình mã hóa mặc định (Server-Side Encryption) và bật Versioning để lưu trữ an toàn file `.tfstate`.
- **DynamoDB Table** sẽ dùng một Partition key tên là `LockID` để Terraform quản lý các phiên bản đang chạy.

## Consequences

### Tích cực (Positives)
- Ngăn ngừa tình trạng ghi đè cấu hình nhờ DynamoDB Lock.
- Bảo vệ an toàn cho dữ liệu (Mã hóa bởi AWS S3 và Versioning).
- Tích hợp sẵn với hệ thống Cloud đang sử dụng, có thể phân quyền IAM chặt chẽ.
- Không phải trả thêm chi phí lớn vì S3 và DynamoDB có mức dùng miễn phí (Free Tier) rất rộng rãi và chi phí lưu state cực kỳ thấp.

### Hạn chế (Negatives)
- Phải tự thiết lập hạ tầng "tiền đề" (S3 và DynamoDB) trước khi có thể chạy Terraform cho các dự án chính.
- Tăng đôi chút phức tạp trong việc quản lý so với việc dùng Terraform Cloud.
