# CI環境設定まとめ（GitHub Actions × Dev Container）

## 1. 目的
`sample-devcontainer` リポジトリで **push だけでテストが自動実行** されるパイプラインを構築し、ローカル環境に依存しない品質確認フローを確立する。

---

## 2. リポジトリ主要構成
```
sample-devcontainer/
├ .devcontainer/
│  ├ Dockerfile
│  └ devcontainer.json
├ .github/
│  └ workflows/
│     └ ci.yml      # ← 今回作成
├ main.py           # FastAPI “Hello, World” サンプル
└ tests/
   └ test_main.py   # API テスト
```

---

## 3. `ci.yml` の内容と要点
```yaml
name: Dev Container CI
on:
  push:
    paths:
      - '.devcontainer/**'
      - 'tests/**'
      - 'main.py'

jobs:
  build-and-test:
    runs-on: ubuntu-latest
    steps:
      # ① リポジトリ取得
      - uses: actions/checkout@v4

      # ② Dev Container をビルドし一時起動
      - uses: devcontainers/ci@v0.2
        with:
          runCmd: pytest -q   # ③ コンテナ内でテスト
          push: never         # イメージはプッシュしない
```

| ステップ | 役割 |
|----------|------|
| **checkout** | ソースコードをランナーに展開 |
| **devcontainers/ci** | Docker Buildx で `.devcontainer/Dockerfile` をビルド後、一時コンテナを立ち上げ `pytest` を実行 |
| **push: never** | テスト専用なのでイメージのレジストリ公開は行わない |

---

## 4. 実行結果の確認方法
1. **GitHub → Actions タブ** を開く  
2. 最新の **Dev Container CI** を選択  
3. `build-and-test` ジョブが ✔ **Success** ならテスト合格  
   失敗時はログ末尾に原因（依存不足・テスト失敗など）が表示

---

## 5. 無料枠について
- パブリックリポジトリのため **GitHub-hosted Runner は無制限無料**  
- プライベートに変更した場合でも月 2,000 分まで無料枠あり

---

## 6. 次のステップ
1. Docker イメージを GHCR へ **ビルド & プッシュ**（`imageName` 指定＋ PAT 追加）  
2. **デプロイジョブ** を追加し、レンタル VPS へ SSH → `docker pull && docker-compose up -d` を自動化  
3. デプロイ後に **curl でヘルスチェック** を実行して完全自動化
