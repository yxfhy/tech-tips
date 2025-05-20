# VSCode × Docker (ML‑Docker‑Playground) 自動化カリキュラム

**対象**：GitHub リポジトリ `yxfhy/ML-Docker-Playground` をクローンし、VS Code で Remote Container (Dev Container) 開発を行う Python／機械学習プロジェクト。  

**期間**：全 8 章（8 週間想定）。各章 90 分〜2 時間の実習を含みます。  

---

## 序章：リポジトリ準備と Dev Container 起動
1. リポジトリをクローン  
   ```bash
   git clone https://github.com/yxfhy/ML-Docker-Playground.git
   cd ML-Docker-Playground
   ```
2. VS Code で **Reopen in Container** を実行  
   - `.devcontainer/devcontainer.json` と `Dockerfile` が自動的にビルドされ、GPU 有無に応じて `Dockerfile` が切り替わる設計。  
3. コンテナ内ターミナルで `python main.py` を試し、環境が動くことを確認  

---

## 第1章：launch.json でワンクリック実行
- **目的**：`python main.py` を *Run & Debug* ボタンで実行する  
- `Run & Debug` → **Python File** を選択 → `launch.json` を自動生成  
- `cwd` を `/workspaces/ML-Docker-Playground` に固定し、`envFile` で `.env` を読む例も設定  

```jsonc
{
  "configurations": [
    {
      "name": "Playground: main",
      "type": "python",
      "request": "launch",
      "program": "main.py",
      "cwd": "${workspaceFolder}",
      "justMyCode": false,
      "envFile": "${workspaceFolder}/.env"
    }
  ]
}
```

---

## 第2章：Docker 内デバッグの深化
- ブレークポイント、変数ウォッチ、ステップ実行  
- VS Code の *Debug Visualizer* を入れてテンソルを画像で確認  
- **Remote Attach**：`python -m debugpy --listen 0.0.0.0:5678 main.py` をタスク化し、外部から接続

---

## 第3章：pytest と Test Explorer
1. コンテナに `pytest` / `pytest-cov` を追加 (`pip install -r requirements-dev.txt`)  
2. コマンドパレット **Python: Configure Tests** → `pytest` → `tests/` を選択  
3. サイドバー **テスト** で  
   - 失敗テストだけ再実行  
   - **F5** でテストをデバッグ

---

## 第4章：tasks.json でビルド・学習・フォーマット
- 例：  
  ```jsonc
  {
    "label": "run-main",
    "type": "process",
    "command": "python",
    "args": ["main.py"],
    "problemMatcher": []
  }
  ```
- `Ctrl + Shift + B` を **run-main** にバインド  
- `black`・`ruff`・`pytest` を個別タスク化し、**compound** タスクで一括実行  

---

## 第5章：Hot‑Reload とデータマウント
- `watchfiles` で Python スクリプトの変更を監視し自動再起動  
  ```bash
  python -m watchfiles python main.py
  ```
- `docker-compose.dev.yml` にホスト側データセットをボリューム共有する例を追加  
- Jupyter Lab を `localhost:8888` 公開し、ノートで素早く検証

---

## 第6章：GPU/CPU スイッチとマルチアーキテクチャ
- `--build-arg ENABLE_CUDA=1` で GPU 版イメージを選択（ML‑Docker‑Playground のビルド引数）  
- `.devcontainer/features.json` で CUDA ドライバの有無を自動検知する書き方  
- GitHub Actions で `matrix: { arch: [cpu, gpu] }` を使った CI 構築

---

## 第7章：pre‑commit と品質ゲート
- `.pre-commit-config.yaml` に  
  ```yaml
  repos:
    - repo: https://github.com/psf/black
      rev: 24.3.0
      hooks: [ { id: black } ]
    - repo: https://github.com/astral-sh/ruff-pre-commit
      rev: v0.3.0
      hooks: [ { id: ruff } ]
    - repo: local
      hooks:
        - id: pytest
          name: pytest
          entry: pytest
          language: system
  ```
- `pre-commit run --all-files` を Tasks で保存時自動実行  

---

## 第8章：Copilot と devcontainer テンプレート生成
- Copilot Chat に  
  > 「ML プロジェクトの `devcontainer.json` に CUDA 自動検知スクリプトを追加して」  
- 生成された差分を確認し、ビルドが通るか再検証  
- `devcontainer.json` バージョンアップ時の **自動リビルド** 設定を学ぶ

---

### 進め方
1. 各章末に触れた設定ファイルを **コミットタグ**（例: `chapter‑2-complete`）で切る  
2. 疑問点は Issue にメモ → 自己回答後 close して学習ログを残す  
3. 毎章の最後に **30 分** でコードを実際に変更し、`pytest` とデバッグを回して定着  

以上が Docker 対応版カリキュラムです。お手元で進めながら不明点があれば随時お申し付けください。