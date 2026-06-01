# Terraform Overview

## 1. Terraform là gì?
Terraform là một công cụ mã nguồn mở do HashiCorp phát triển, cho phép quản lý hạ tầng dưới dạng code (Infrastructure as Code - IaC).
**Tính năng chính:**
- Quản lý đa nền tảng cloud (AWS, Azure, GCP,...) thông qua hệ thống Provider.
- Sử dụng cú pháp HCL dễ đọc, dễ viết.
- Có khả năng lên kế hoạch (Plan) và dự đoán trước những thay đổi trước khi áp dụng lên hạ tầng thực tế.
- Tự động hóa việc tạo mới, cập nhật và hủy bỏ tài nguyên một cách an toàn.

## 2. Infrastructure as Code (IaC)
IaC là việc quản lý và cấp phát tài nguyên máy tính thông qua file định nghĩa máy đọc được (code), thay vì cấu hình phần cứng vật lý hoặc sử dụng các công cụ cấu hình tương tác (như click trên UI của Cloud Console).
**Lý do dùng Terraform thay vì click UI:**
- **Tính tự động hóa:** Dễ dàng triển khai lại hạ tầng trên nhiều môi trường mà không tốn sức lặp lại các thao tác click chuột.
- **Kiểm soát phiên bản (Version Control):** Code hạ tầng được lưu vào Git, giúp review code, theo dõi ai thay đổi cái gì và dễ dàng rollback khi xảy ra lỗi.
- **Giảm rủi ro (Human Error):** Click thủ công rất dễ sót cấu hình, IaC giúp mọi thứ chuẩn hóa và nhất quán.
- **Tài liệu hóa:** Bản thân file Terraform chính là tài liệu mô tả kiến trúc hệ thống hiện tại.

## 3. Terraform Workflow
- **terraform init:** Khởi tạo thư mục làm việc, tải các provider cần thiết và thiết lập backend.
- **terraform plan:** So sánh trạng thái hiện tại với code, tính toán và hiển thị trước những thay đổi sẽ diễn ra.
- **terraform apply:** Xác nhận và tiến hành gọi API của provider để áp dụng những thay đổi lên hạ tầng.
- **terraform destroy:** Tính toán và xóa toàn bộ hoặc một số tài nguyên đang được Terraform quản lý.
