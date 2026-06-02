# Bài tập 2: Expose ứng dụng bằng Service

## Mục đích
Học cách sử dụng Kubernetes Service để gom nhóm các Pod và cung cấp điểm truy cập mạng (networking) cho chúng.

## Yêu cầu thực hành

1. Copy lại file `nginx-pod.yaml` từ bài tập 1 qua thư mục này và apply nó (`kubectl apply -f nginx-pod.yaml`) để đảm bảo bạn có một Pod Nginx đang chạy với label `app: webserver`.
2. Tạo một file tên là `nginx-service.yaml`.
3. Cấu hình file YAML để tạo một K8s Service:
   - Tên Service: `my-nginx-svc`
   - Loại Service (Type): `NodePort`
   - Selector: Trỏ tới `app: webserver` (để match với label của Pod).
   - Port cấu hình:
     - `port`: 80 (Port mà service sẽ lắng nghe bên trong cluster).
     - `targetPort`: 80 (Port của container).
     - `nodePort`: 30080 (Port sẽ được mở trên Node, chọn port tĩnh từ 30000-32767).

## Hướng dẫn Test
1. Apply file service:
   ```bash
   kubectl apply -f nginx-service.yaml
   ```
2. Kiểm tra xem service đã nhận diện đúng Pod chưa (Endpoints):
   ```bash
   kubectl get svc
   kubectl get endpoints my-nginx-svc
   ```
3. Đối với Minikube, để truy cập NodePort từ trình duyệt máy thật, hãy dùng lệnh:
   ```bash
   minikube service my-nginx-svc
   # Minikube sẽ tự động mở trình duyệt hoặc cấp cho bạn một đường dẫn URL (tunnel).
   ```
4. Dọn dẹp:
   ```bash
   kubectl delete -f nginx-service.yaml
   kubectl delete -f nginx-pod.yaml
   ```
