# Ngày B: Self-study Kubernetes (K8s) — Kiến thức nền về Container/Orchestration

## Mục Tiêu Bài Học
Nắm vững các khái niệm cơ bản nhất của Kubernetes (K8s) trước khi bước vào thực hành lab trên Minikube. Cụ thể:
- Khái niệm về **Pod**, thành phần nhỏ nhất trong K8s.
- Hiểu cách các container giao tiếp và được expose ra ngoài qua **Service**.
- Biết cách kiểm tra sức khỏe của ứng dụng với **Probes**.
- Phân biệt và ứng dụng **ConfigMap** và **Secret** để tách biệt cấu hình khỏi code.
- Hiểu khái niệm **NetworkPolicy** để bảo mật mạng lưới (security/firewall cho K8s).

---

## 1. Pod (Đơn vị nhỏ nhất)
- Trong K8s, bạn không chạy container trực tiếp. Bạn chạy **Pod**.
- Một Pod bọc quanh 1 hoặc nhiều container. Các container trong cùng một Pod chia sẻ chung Network (cùng IP, port), Storage (Volume) và chạy trên cùng một Node.
- *Ví dụ*: Một Pod chứa container `nginx` (web) và container `fluentd` (để gom log).

## 2. Service (Networking và Load Balancing)
- Pods rất "mỏng manh" (ephemeral) — chúng có thể bị chết và tạo lại liên tục với IP mới.
- **Service** giải quyết vấn đề này bằng cách cung cấp một IP tĩnh và một cái tên DNS cố định để truy cập một nhóm Pod (dựa trên `selector` và `labels`).
- **Các loại Service chính:**
  - `ClusterIP` (mặc định): Chỉ truy cập được từ bên trong cluster.
  - `NodePort`: Mở một port tĩnh (30000-32767) trên mỗi Node của cluster để từ ngoài vào.
  - `LoadBalancer`: Tự động gọi Cloud Provider (AWS, GCP) để cấp một Public Load Balancer thật sự.

## 3. Health Probes (Liveness, Readiness, Startup)
Làm sao K8s biết container của bạn đang chạy tốt hay bị treo? Nó dùng Probes!
- **Liveness Probe**: Container có đang sống không? Nếu chết (treo, deadlock), K8s sẽ restart container.
- **Readiness Probe**: Container đã sẵn sàng nhận traffic chưa? Nếu chưa (đang load data, init...), K8s sẽ không đẩy request từ Service vào Pod này.
- **Startup Probe**: Dùng cho các ứng dụng khởi động chậm (vượt quá thời gian chờ của Liveness). Chỉ khi Startup probe pass thì Liveness/Readiness mới được kích hoạt.

## 4. ConfigMap và Secret (Quản lý cấu hình)
Tuân thủ nguyên tắc [12-Factor App](https://12factor.net/), cấu hình nên được tách khỏi Code.
- **ConfigMap**: Lưu trữ dữ liệu cấu hình thông thường (dạng Key-Value, file cấu hình, JSON, ...). Không mã hóa.
- **Secret**: Lưu trữ thông tin nhạy cảm (Passwords, Tokens, SSH Keys). Dữ liệu được mã hóa base64 (mặc định) và có thể tích hợp KMS để bảo mật hơn.
- Cả 2 có thể được đưa vào Pod dưới dạng **Environment Variables** hoặc mount thành **Files trong Volume**.

## 5. NetworkPolicy (Bảo mật mạng)
- Mặc định trong K8s, mọi Pod đều có thể nói chuyện với mọi Pod khác.
- **NetworkPolicy** đóng vai trò giống như Security Groups/Firewall, cho phép bạn định nghĩa các luật (rules) để giới hạn traffic:
  - **Ingress**: Traffic đi vào Pod.
  - **Egress**: Traffic từ Pod đi ra ngoài.
- Dựa trên labels để xác định nguồn và đích.

---

## 🚀 Hướng Dẫn Thực Hành (Day B)
Trong thư mục `exercises`, bạn sẽ tự viết các file định nghĩa `.yaml` (Manifests) để luyện tập. Hãy dùng Minikube để apply và test nhé!

1. **`ex1-pods-and-probes`**: Viết YAML tạo Pod với Nginx và cấu hình các Probe.
2. **`ex2-services`**: Viết YAML tạo Service để expose Nginx ra ngoài.
3. **`ex3-config-and-secrets`**: Viết YAML tạo ConfigMap/Secret và mount vào Pod.
4. **`ex4-networkpolicy`**: Viết luật giới hạn mạng cơ bản.

> **Mẹo**: Sử dụng lệnh `kubectl explain <resource>` (VD: `kubectl explain pod.spec.containers.livenessProbe`) để xem tài liệu tham khảo ngay trên terminal!
