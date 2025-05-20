
# Weekly Lesson: Full-Scratch CI/CD Pipeline with FastAPI, Docker, and AWS EC2

このレッスンでは、以下のステップを通じて、FastAPI アプリケーションを Docker 化し、GitHub Actions で CI/CD を構築し、最終的に AWS EC2 上で自動デプロイするまでの一連のフローを **ゼロから** 学びます。

---

## 目的
1. **FastAPI “Hello, World”** エンドポイントの作成  
2. **Dockerfile** でコンテナーイメージ化  
3. **VS Code Dev Container** 設定  
4. **pytest** テスト実行  
5. **GitHub リモート設定** & **タグ運用**  
6. **CI（GitHub Actions）**: テスト→ビルド→GHCR プッシュ  
7. **Docker Compose & Deploy**: GHCR からイメージをプル→EC2 へ SSH デプロイ→ヘルスチェック  
8. **AWS EC2**: インスタンス作成→公開鍵認証→公式 Docker & Compose V2→再起動対応  

---

## プロジェクト構成
```
.
├── .devcontainer/
│   ├── Dockerfile
│   └── devcontainer.json
├── .github/
│   └── workflows/
│       ├── ci.yml
│       ├── docker.yml
│       └── deploy.yml
├── tests/
│   ├── __init__.py
│   └── test_main.py
├── Dockerfile
├── docker-compose.example.yml
├── main.py
├── README.md
└── requirements.txt
```

---

## 1. FastAPI アプリ & テスト

- **main.py**
  ```python
  from fastapi import FastAPI
  app = FastAPI()

  @app.get("/")
  def root():
      return {"message": "Hello, World"}
  ```
- **tests/test_main.py**
  ```python
  from fastapi.testclient import TestClient
  from main import app

  client = TestClient(app)

  def test_root():
      r = client.get("/")
      assert r.status_code == 200
      assert r.json() == {"message": "Hello, World"}
  ```
- `pytest` 実行時に `tests/__init__.py` が必要。
- `requirements.txt` に `fastapi`, `uvicorn[standard]`, `pytest`, `httpx` を含める。

---

## 2. Dockerfile & Dev Container

- **Dockerfile**（本番用）
  ```dockerfile
  FROM python:3.11-slim
  WORKDIR /app
  COPY requirements.txt .
  RUN pip install --no-cache-dir -r requirements.txt
  COPY . .
  EXPOSE 8000
  CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
  ```
- **.devcontainer/devcontainer.json**
  ```jsonc
  {
    "name": "hello-fastapi",
    "build": { "context": "..", "dockerfile": "Dockerfile" },
    "features": { "ghcr.io/devcontainers/features/git:1": {} },
    "forwardPorts": [8000],
    "postCreateCommand": "pip install -r requirements.txt"
  }
  ```
- VS Code で「Reopen in Container」を実行。

---

## 3. Git & GitHub リモート

```bash
git init
git branch -M main
git remote add origin <GitHub リポジトリ URL>
git add .
git commit -m "初期セットアップ"
git push -u origin main
```

- リモート作成・上流設定に `git push -u origin main` を使用。

---

## 4. GitHub Actions: CI

**.github/workflows/ci.yml**
```yaml
name: CI
on: [push]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: devcontainers/ci@v0.2
        with:
          runCmd: pytest -q
          push: never
```

---

## 5. GitHub Actions: Docker Build & Push

**.github/workflows/docker.yml**
```yaml
name: Docker Build & Push
on:
  push:
    tags: ["v*.*.*"]
jobs:
  build-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    steps:
      - uses: actions/checkout@v4
      - uses: docker/setup-buildx-action@v3
      - uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.CR_PAT }}
      - uses: docker/build-push-action@v5
        with:
          push: true
          tags: ghcr.io/${{ github.repository }}:latest
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

---

## 6. シークレット登録 (GitHub)

- **CR_PAT**: write:packages 権限付き Personal Access Token  
- **SSH_HOST**: EC2 のパブリック IP/DNS  
- **SSH_USER**: `ubuntu`  
- **SSH_KEY**: `-----BEGIN OPENSSH PRIVATE KEY-----` から `END` まで全文  

---

## 7. GitHub Actions: Deploy

**.github/workflows/deploy.yml**
```yaml
name: Deploy
on:
  workflow_run:
    workflows: ["Docker Build & Push"]
    types: [completed]
jobs:
  deploy:
    if: ${{ github.event.workflow_run.conclusion == 'success' }}
    runs-on: ubuntu-latest
    steps:
      - name: SSH & Redeploy
        uses: appleboy/ssh-action@v1
        with:
          host: ${{ secrets.SSH_HOST }}
          username: ${{ secrets.SSH_USER }}
          key: ${{ secrets.SSH_KEY }}
        script: |
          docker pull ghcr.io/${{ github.repository }}:latest
          docker compose -f /srv/app/docker-compose.yml up -d
          sleep 5
          curl -fsSL http://localhost:8000/ | grep '"Hello, World"' || exit 1
```

---

## 8. AWS EC2 セットアップ

1. **EC2 インスタンス起動** (Ubuntu 22.04, t2.micro)  
2. **キーペア作成 & ダウンロード** → `hello-fastapi-key.pem`  
3. **セキュリティグループ**:  
   - SSH (22) 全開 + 公開鍵認証のみ許可  
   - TCP 8000 全開  
4. **公開鍵のみ認証**: `/etc/ssh/sshd_config` で `PasswordAuthentication no`  
5. **Docker 公式インストール & Compose V2**  
   ```bash
   sudo apt remove -y docker.io docker-compose
   sudo apt update
   sudo apt install -y ca-certificates curl gnupg lsb-release
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg      | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
   echo      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg]      https://download.docker.com/linux/ubuntu      $(lsb_release -cs) stable"      | sudo tee /etc/apt/sources.list.d/docker.list
   sudo apt update
   sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
   sudo systemctl enable docker
   sudo usermod -aG docker ubuntu
   ```  
6. **自動起動 & コンテナー再起動設定**:  
   - `sudo systemctl enable docker`  
   - `docker compose -f /srv/app/docker-compose.yml up -d`  

---

## 9. 初回手動デプロイ

```bash
ssh -i ~/.ssh/hello-fastapi-key.pem ubuntu@<EC2_IP>
echo "<CR_PAT>" | docker login ghcr.io -u <GitHubユーザー> --password-stdin
cd /srv/app
docker compose up -d
curl http://localhost:8000/
```

---

## 10. リリース & 自動デプロイ

1. タグ付与: `git tag vX.Y.Z`  
2. タグプッシュ: `git push origin --tags`  
3. GitHub Actions で自動実行 (CI→Build&Push→Deploy)

---

以上で**誰でも再現可能**な完全ゼロからの CI/CD パイプラインレッスンは完了です。
