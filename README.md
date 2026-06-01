# PhanLeThanhHoang-aws-accelerator-p2

Portfolio cá nhân cho **AWS Accelerator Phase 2 (Cloud/DevOps Track)**.

## Thông tin chung
- **Thời gian:** 01/06/2026 - 03/07/2026 (5 tuần)
- **Nội dung chính:** IaC (Terraform), K8s, GitOps, Observability, Canary, Security.
- **Hoạt động:** Self-study online (T2-T4) và Onsite Lab tại Đà Nẵng (T5-T6).

## Cấu trúc Repository

Dự án được chia thành các thư mục tương ứng với từng tuần và từng giai đoạn:

```text
cloud/
  w8/           # Foundation: IaC + K8s
    day-a/      # Terraform (Overview, HCL, State, Modules, Best Practices)
    day-b/      # K8s Container/Orchestration (Pod, Service, probes, ConfigMap/Secret...)
    day-c/      # K8s Scaling + Networking
    lab/        # Minimal K8s platform trên minikube
    reflection.md # Đánh giá, tổng kết tuần 8
  w9/           # (Nội dung tiếp theo: GitOps, Observability...)
  w10/          # (Nội dung tiếp theo: Canary, Security...)
capstone/
  w11/          # Capstone cross-team pod - Phần 1
  w12/          # Capstone cross-team pod - Phần 2 (Pitching 03/07)
```

## Các Tools sử dụng trong W8
- **Terraform**
- **Docker Desktop / Docker Engine**
- **minikube**
- **kubectl**

## Quy định Commit & Push
- **Format Commit Message:** `[W8-D1] <topic ngắn>` (Ví dụ: `[W8-D1] Add Terraform overview notes`, thay đổi `D1`, `D2` tùy ngày).
- **Tần suất:** Yêu cầu push code lên repo hằng ngày (từ Thứ 2 đến Thứ 4) để mentor track tiến độ học tập và thực hành.