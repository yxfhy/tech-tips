# Week 2: Dockerfile & Buildx

## 目標
- 自作イメージをマルチアーキテクチャ（linux/amd64, linux/arm64）でビルドし、リモートレジストリへPushする

## レッスン内容
1. **Dockerfile の作成**
   ```dockerfile
   FROM python:3.11-slim

   WORKDIR /app
   COPY ./main.py /app/main.py

   RUN pip install --no-cache-dir fastapi uvicorn

   CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
   ```

2. **Buildx のセットアップ**
   - Buildx は Docker CLI のプラグインで、BuildKit を用いた高速・マルチプラットフォームビルドを提供  
   - **ビルダー作成**  
     ```bash
     docker buildx create --name multi-builder --use
     ```
   - **QEMU エミュレーション有効化**  
     ```bash
     docker buildx inspect multi-builder --bootstrap
     ```
   - **プラットフォーム確認**  
     ```bash
     docker buildx ls
     ```

## ハンズオン：FastAPIサンプルの用意
1. ディレクトリ作成とアプリコード作成  
   ```bash
   mkdir fastapi-sample && cd fastapi-sample
   cat << 'EOF' > main.py
   from fastapi import FastAPI

   app = FastAPI()

   @app.get("/hello")  # /docs から /hello に変更
   def read_hello():
       return {"message": "Hello, world!"}
   EOF
   ```

2. Dockerfile 作成  
   ```bash
   cat << 'EOF' > Dockerfile
   FROM python:3.11-slim

   WORKDIR /app
   COPY ./main.py /app/main.py

   RUN pip install --no-cache-dir fastapi uvicorn

   CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
   EOF
   ```

3. マルチアーキビルド＆Push  
   ```bash
   docker buildx build      --platform linux/amd64,linux/arm64      -t yxfhy/fastapi-sample:latest      --push      .
   ```

4. ノートパソコンでの Pull & 実行  
   ```bash
   docker pull yxfhy/fastapi-sample:latest
   docker run --rm -d -p 8000:8000 --name fastapi-laptop yxfhy/fastapi-sample:latest
   ```

5. 動作確認  
   - JSON のみ返す方法  
     ```bash
     curl -H "Accept: application/json" http://localhost:8000/hello
     ```
   - 直接パスを見る場合  
     ```bash
     curl http://localhost:8000/hello
     ```

## Q&A & 疑問点まとめ

- **ビルドとは？**  
  ソースコードや設定、ライブラリをまとめて「動くパッケージ（イメージ）」にする工程

- **Buildx とは？**  
  Dockerの公式プラグインで、BuildKitを使ったマルチプラットフォーム・高速ビルドを実現

- **マルチプラットフォームビルド**  
  `--platform linux/amd64,linux/arm64` で Intel/AMD (amd64) と ARM (arm64) 向けイメージを同時ビルドし、マニフェストリストにまとめる

- **レジストリ**  
  イメージを保存・管理・配布するリポジトリ（例：Docker Hub, AWS ECR, GitLab Container Registry）

- **ファイルシステムスナップショット**  
  イメージは特定時点のユーザーランド（アプリのファイル、`/etc`, `/usr` など）をまとめたもの。カーネルは含まず、起動時にホストのカーネルを利用

- **イメージとコンテナ**  
  - イメージ＝設計図（クラス）  
  - コンテナ＝インスタンス

- **`--push` vs `--load`**  
  - `--push`: リモートへアップロード、ローカル未ロード  
  - `--load`: ローカルデーモンへロード（ホストアーキ向けのみ）

- **Docker Hub ログイン**  
  ```bash
  docker login
  ```

- **WSL2＋Docker Desktop 連携**  
  Docker Desktop 設定 → Resources → WSL Integration で Ubuntu 有効化  
  Ubuntu 上から `docker version` が確認可能

- **WSL の Interop**  
  Ubuntu シェルから `notepad.exe` を実行可能  
  `/mnt/c` で Windows ドライブ共有

- **シェル環境改善**  
  - Windows Terminal + WSL2  
  - Git Bash / Cmder / MobaXterm  
  - PowerShell + PSReadLine

---

以上が今回のまとめでございます。
