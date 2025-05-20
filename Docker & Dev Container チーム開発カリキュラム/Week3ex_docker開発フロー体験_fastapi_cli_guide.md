
# Week_3extra_Docker 開発体験フルガイド  
（FastAPI ホットリロード & CLI 画像処理ツール）

作成 : 2025-04-30
作者 : ご主人さまの開発メモ

---

## 0. 目次
1. 前提環境
2. WSL と Docker の基礎知識
3. ディレクトリ整備 & mkcd 関数
4. Hands‑on ① – FastAPI＋Docker＋ホットリロード
5. Hands‑on ② – 画像処理 CLI ツール＋Docker
6. Git 運用とチーム共有
7. よくある質問 (Q&A チートシート)
8. 片付け・便利コマンド集

---

## 1. 前提環境
- Windows 11 + WSL2（Ubuntu）
- Docker Desktop (WSL Integration 有効)
- VSCode (Remote‑WSL 拡張)

```bash
# WSL 側で Docker コマンドが動くか確認
docker --version
docker compose version     # プラグイン形式
```

---

## 2. WSL と Docker の基礎
|   | WSL 上の Ubuntu | Docker コンテナ |
|---|---|---|
| レイヤー | 軽量 VM | OS レベルの隔離 |
| 起動 | 常駐 | `run` / `compose up` |
| ファイル | ホスト直下 | イメージ + 書込レイヤ |
| 役割 | 開発用シェル | アプリ実行環境 |

- **イメージ vs ISO** : イメージはレイヤ差分の集合体で軽量、ISO は全体コピーで固定。
- **Compose とは** : 複数サービスを YAML で宣言し、一括ビルド・起動・停止を管理。

---

## 3. ディレクトリ整備 & mkcd
```bash
# ~/.bashrc に追記
mkcd() {
  mkdir -p "$1" && cd "$1"
}
source ~/.bashrc

# 使い方
mkcd ~/projects/fastapi-docker
```
構造例 :
```
projects/
├── fastapi-docker/
└── image-cli/
```

---

## 4. Hands‑on ① FastAPI ホットリロード

### 4‑1. ファイル構成
```
fastapi-docker/
├── main.py
├── requirements.txt
├── Dockerfile
└── docker-compose.yml
```

### 4‑2. main.py
```python
from fastapi import FastAPI
app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Hello, world!"}
```

### 4‑3. requirements.txt
```
fastapi
uvicorn[standard]
```

### 4‑4. Dockerfile
```dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["uvicorn","main:app","--host","0.0.0.0","--port","8000","--reload"]
```

### 4‑5. docker-compose.yml
```yaml
version: "3.8"
services:
  web:
    build: .
    volumes:
      - .:/app          # ← バインドマウント
    ports:
      - "8000:8000"
```

### 4‑6. 起動
```bash
docker compose up --build
```
- `http://localhost:8000/` へアクセス
- `main.py` を保存するだけで **自動リロード** → ブラウザ再読込で反映

---

## 5. Hands‑on ② 画像処理 CLI ツール

### 5‑1. 構成
```
image-cli/
├── main.py
├── requirements.txt
└── Dockerfile
```

### 5‑2. main.py
```python
import click
from PIL import Image, ImageFilter

@click.command()
@click.option("--input","-i","in_path",required=True)
@click.option("--output","-o","out_path",required=True)
@click.option("--blur","-b",default=2)
def process_image(in_path,out_path,blur):
    img = Image.open(in_path)
    gray = img.convert("L")
    gray.filter(ImageFilter.GaussianBlur(blur)).save(out_path)
    click.echo(f"処理完了でーす：{out_path}")

if __name__=="__main__":
    process_image()
```

### 5‑3. requirements.txt
```
click
pillow
```

### 5‑4. Dockerfile
```dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY main.py .
ENTRYPOINT ["python","main.py"]
```

### 5‑5. サンプル画像配置
```
mkdir sample
# input.jpg を sample/ に置く
```

### 5‑6. 実行方法
#### A) イメージビルド方式
```bash
docker build -t image-cli .
docker run --rm -v "$(pwd)/sample:/data" image-cli   --input /data/input.jpg --output /data/output.jpg --blur 5
```
#### B) バインドマウント方式 (ビルド不要)
```bash
docker run --rm   -v "$(pwd)":/app   -v "$(pwd)/sample":/data   image-cli   --input /data/input.jpg --output /data/output.jpg --blur 5
```

---

## 6. Git 運用
```bash
git init
echo -e "__pycache__/\n*.py[cod]\n.sample*\n.vscode/" > .gitignore
git add .
git commit -m "initial commit"
```
- `requirements.txt` や `Dockerfile` を変更したら **チーム全員が pull → build** で環境統一  
- 新ライブラリを追加したら `git push` して共有

---

## 7. Q&A チートシート

| 質問 | 短答 |
|---|---|
| コンテナとは？ | OS カーネル共有の軽量仮想環境 |
| `uvicorn --reload` は誰が監視？ | watchfiles ライブラリがファイル変更を監視 |
| `docker run --rm` 意味 | 終了後にコンテナを自動削除 |
| イメージ再ビルドは？ | 依存や Dockerfile を変えた時のみ |
| 停止コンテナはメモリ使う？ | いいえ。ディスクレイヤのみ占有 |
| Compose の利点 | 複数サービスを YAML で宣言し一括管理 |
| Image ↔ ISO | イメージはレイヤ差分、ISO は丸ごとコピー |
| Docker Hub へ push | `docker push user/repo:tag` でレイヤ自動アップ |

---

## 8. お片付け & 便利コマンド

```bash
# 停止中コンテナだけ削除
docker container prune -f

# 使わないイメージ・ボリュームも全削除
docker system prune --all --volumes -f

# Compose ログをライブ表示
docker compose logs -f

# Explorer で sample フォルダを開く (Windows)
explorer.exe `wslpath -w $(pwd)/sample`
```

---

> **備考** : 画像がドラッグ出来ない場合は `sudo chown -R <user>:<user> sample` で所有者を変更。  
> mkcd 関数で作業ディレクトリ作成を高速化。

---
