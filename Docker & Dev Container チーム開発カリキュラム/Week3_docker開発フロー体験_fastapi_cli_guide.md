# Week 3 実践ガイド — docker‑compose と GPU 切替開発フロー

このドキュメントは **CPU しか持たない開発者** と **GPU を持つ開発者**が同じコードベースを共有し、  
`docker‑compose --profile cpu|gpu` で簡単に切り替えて動かせる一連の手順を再現できるようまとめたものです。  
ここに書かれているファイルをそのまま配置して実行すれば、ご主人さまが体験された一連を誰でも再現できます。

---
## フォルダ構成

```text
proj1/
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
└── inference.py
```

---
## 1. 各ファイルの内容

### 1‑1. `inference.py` ― CPU/GPU ベンチマークスクリプト

```python
import argparse, time, torch, torch.nn as nn

def run(device_label: str):
    device = torch.device("cuda" if device_label == "gpu" and torch.cuda.is_available() else "cpu")
    model = nn.Sequential(
        nn.Linear(1024, 512),
        nn.ReLU(),
        nn.Linear(512, 10)
    ).to(device)
    dummy = torch.randn(1, 1024, device=device)
    # ウォームアップ
    for _ in range(10):
        _ = model(dummy)
    # ベンチ
    start = time.time()
    for _ in range(100):
        _ = model(dummy)
    print(f"[{device.type.upper()}] average {(time.time()-start)/100:.6f}s")

if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("--device", choices=["cpu", "gpu"], default="cpu")
    args = p.parse_args()
    run(args.device)
```

### 1‑2. `requirements.txt`

```
torch
```

> **FastAPI を試したい場合**は `fastapi uvicorn[standard]` を追記し、CMD を uvicorn に書き換えてください。

### 1‑3. `Dockerfile`

```dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python", "inference.py", "--device", "cpu"]
```

### 1‑4. `docker-compose.yml`

```yaml
version: "3.8"

services:
  inference_cpu:
    build: .
    command: python inference.py --device cpu
    profiles: [cpu]

  inference_gpu:
    build: .
    command: python inference.py --device gpu
    runtime: nvidia         # NVIDIA コンテナランタイムがある場合のみ
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              capabilities: [gpu]
    profiles: [gpu]
```

---
## 2. 実行手順

### 2‑1. CPU モード
```bash
docker compose --profile cpu up --build     # 初回のみ --build
```

### 2‑2. GPU モード
```bash
docker compose --profile gpu up --build
```

*GPU 非搭載マシンでは `runtime nvidia not found` で失敗します。CPU モードをご使用ください。*

---
## 3. 学んだポイントまとめ

| カテゴリ | 要点 |
|----------|------|
| compose profiles | `--profile cpu|gpu` でサービスを切替。共有コードで 1 ファイル。 |
| NVIDIA ランタイム | `runtime: nvidia` または `deploy.resources.reservations.devices` で GPU パススルー。 |
| イメージ容量 | PyTorch CUDA 版は展開後 8 GB 超。CPU 専用ホイールで軽量化可。 |
| docker compose v2 | Ubuntu 標準の旧 `docker-compose` は `http+docker://` エラーを起こす場合あり。`docker-compose-plugin` を apt で導入し **`docker compose`** を使用する。 |
| WSL/EC2 デーモン | `sudo service docker start` / `systemctl enable docker`。環境変数 `DOCKER_HOST` を誤設定しない。 |
| AWS クォータ | GPU インスタンス (g4dn) は「G and VT vCPU」クォータを Service Quotas で増加申請。 |

---
## 4. AWS GPU テスト手順（抜粋）

1. **AMI**: Deep Learning Base OSS Nvidia Driver GPU (Ubuntu 22.04)  
2. **インスタンスタイプ**: g4dn.xlarge (スポット可)  
3. **クォータ**: Service Quotas → *Running On‑Demand G and VT instances* → Increase (例 8 vCPU)  
4. **SSH 鍵配置**: `~/.ssh/aws_keys/my-key.pem` → `chmod 400`  
5. **Docker 起動**: `sudo service docker start && sudo apt install docker-compose-plugin`  
6. **プロジェクト clone & up**: `git clone … && docker compose --profile gpu up --build`  

これで CPU / GPU 両環境で同一スクリプトが動作し、ログの平均推論時間差を確認できます。

---
## 5. 変更履歴が要る場合

依存ライブラリ追加・Dockerfile 変更など「イメージを変える」タイミングでのみ `docker compose build` を再実行し、ソースコード編集だけならホットリロードまたはコンテナ再起動で高速反復できます。

---
### Happy Container Hacking!  
