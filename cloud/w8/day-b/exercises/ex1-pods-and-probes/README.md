# Bài tập 1: Pods & Health Probes

## Mục đích
Học cách viết file Manifest `.yaml` cho một Pod cơ bản và biết cách cấu hình cơ chế kiểm tra sức khoẻ (Probes) cho ứng dụng bên trong.

## Yêu cầu thực hành

1. Tạo một file tên là `nginx-pod.yaml` trong thư mục này.
2. Cấu hình file YAML để tạo một Kubernetes Pod:
   - Tên Pod: `my-nginx-pod`
   - Labels: `app: webserver`
   - Container name: `nginx-container`
   - Image: `nginx:alpine`
   - Expose port `80`.
3. Thêm cấu hình **Liveness Probe** cho container:
   - Dùng phương thức HTTP GET tới đường dẫn `/`.
   - Port kiểm tra: 80.
   - Chạy kiểm tra sau 5 giây (initial delay).
   - Kiểm tra mỗi 10 giây.
4. Thêm cấu hình **Readiness Probe** cho container:
   - Dùng phương thức HTTP GET tới đường dẫn `/`.
   - Port kiểm tra: 80.

## Hướng dẫn Test bằng Minikube
1. Khởi động minikube (nếu chưa chạy): `minikube start`
2. Apply file YAML: 
   ```bash
   kubectl apply -f nginx-pod.yaml
   ```
3. Xem trạng thái của Pod:
   ```bash
   kubectl get pods
   kubectl describe pod my-nginx-pod
   ```
   *(Hãy để ý mục `Events` và phần thông tin `Liveness` / `Readiness` trong mô tả)*
4. Dọn dẹp: 
   ```bash
   kubectl delete -f nginx-pod.yaml
   ```
