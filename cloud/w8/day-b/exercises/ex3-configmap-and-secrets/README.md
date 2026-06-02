# Bài tập 3: Quản lý cấu hình với ConfigMap & Secret

## Mục đích
Học cách tách rời cấu hình và thông tin nhạy cảm ra khỏi code/image, và đưa chúng vào Pod một cách an toàn.

## Yêu cầu thực hành

### 1. Tạo ConfigMap và Secret
Tạo một file tên là `config-secret.yaml` chứa CẢ 2 tài nguyên:
- **ConfigMap** tên là `app-config`:
  - Chứa biến `APP_ENV: "production"`
  - Chứa biến `LOG_LEVEL: "debug"`
- **Secret** tên là `app-secret` (nhớ đổi Secret type về `Opaque`):
  - Chứa biến `DB_PASSWORD: "my-super-secret-password"` 
  - *(Ghi chú: Giá trị trong file YAML của Secret bắt buộc phải được encode sang dạng Base64. Bạn có thể dùng `echo -n "my-super-secret-password" | base64` trên terminal để lấy chuỗi đã mã hóa).*

### 2. Sử dụng trong Pod
Tạo một file tên là `app-pod.yaml`:
- Chạy một Pod với image `busybox` hoặc `alpine`.
- Lệnh chạy (command/args): chạy lệnh `env` hoặc sleep vô tận `sleep 3600` để có thời gian kiểm tra.
- **Tiêm (Inject) cấu hình**: 
  - Khai báo Environment Variables cho container, lấy giá trị `APP_ENV` từ ConfigMap.
  - Khai báo Environment Variables lấy giá trị `DB_PASSWORD` từ Secret.

## Hướng dẫn Test
1. Apply cả 2 file:
   ```bash
   kubectl apply -f config-secret.yaml
   kubectl apply -f app-pod.yaml
   ```
2. Truy cập vào bên trong pod để kiểm tra xem biến môi trường có tồn tại không:
   ```bash
   kubectl exec -it <tên-pod-của-bạn> -- env | grep -E "APP_ENV|DB_PASSWORD"
   ```
3. Dọn dẹp:
   ```bash
   kubectl delete -f app-pod.yaml
   kubectl delete -f config-secret.yaml
   ```
