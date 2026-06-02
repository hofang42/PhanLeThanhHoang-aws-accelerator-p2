# Bài tập 4: Network Policies

## Mục đích
Hiểu cách thiết lập tường lửa (firewall) bên trong Kubernetes Cluster để kiểm soát các Pod nào được phép gọi nhau.

## Bối cảnh thực hành
Giả sử bạn có 2 nhóm Pods:
1. `backend-pod` (có label `app: backend`, `role: db`)
2. `frontend-pod` (có label `app: frontend`)

Bạn muốn cài đặt luật: **Chỉ có các pod frontend mới được phép truy cập vào backend-pod ở cổng 3306. Mọi kết nối khác đều bị cấm.**

## Yêu cầu thực hành
Viết một file `network-policy.yaml`:
- **Loại tài nguyên**: `NetworkPolicy`.
- **Tên**: `db-network-policy`
- **PodSelector**: áp dụng lên các pod có label `role: db`.
- **PolicyTypes**: Chỉ áp dụng cho `Ingress` (chiều vào).
- **Ingress Rule**:
  - Cho phép (`from`) các pod có label `app: frontend`.
  - Cổng mở (`ports`): 3306 (TCP).

*(Lưu ý: Để test NetworkPolicy thực sự, Cluster K8s của bạn phải cài đặt một mạng CNI có hỗ trợ NetworkPolicy như Calico, Cilium... Minikube mặc định không có bật sẵn CNI này, nên bài này bạn chủ yếu thực hành **cách viết syntax** và `apply` thành công tài nguyên lên Cluster).*

## Hướng dẫn Test (Syntax)
1. Apply file:
   ```bash
   kubectl apply -f network-policy.yaml
   ```
2. Kiểm tra tài nguyên đã được tạo:
   ```bash
   kubectl describe networkpolicy db-network-policy
   ```
3. Dọn dẹp:
   ```bash
   kubectl delete -f network-policy.yaml
   ```
