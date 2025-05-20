# Week0 GitHub Copilot導入ガイド

## はじめに
このガイドは、GitHub Copilot、Copilot Chat、JupyterをDev Container環境で利用開始するための手順とQ&A、発生した問題点と対処法をまとめたものです。  
このガイドで作成したファイルはここ→ https://github.com/yxfhy/ML-Docker-Playground  
---

## 1. バージョン確認
### Node.js ≥ 18
```bash
node -v
# → v18.x.x 以上であることを確認
```

### Python ≥ 3.10
```bash
python3 --version
# または python --version
# → Python 3.10.x 以上であることを確認
```

---

## 2. Dockerfile
以下を `Dockerfile` として保存してください。

```dockerfile
# ベースイメージを指定 (image プロパティ相当)
FROM nvcr.io/nvidia/pytorch:25.04-py3

# ───────────────────────────────
# 1) Git をインストール
#   feature: ghcr.io/devcontainers/features/git:1 相当
RUN apt-get update  && apt-get install -y --no-install-recommends git  && rm -rf /var/lib/apt/lists/*

# ───────────────────────────────
# 2) Node.js 18.x をインストール
#    curl がなければ先に導入し、NodeSource のセットアップスクリプトで nodejs を追加します。
RUN apt-get update  && apt-get install -y --no-install-recommends curl  && curl -fsSL https://deb.nodesource.com/setup_18.x | bash -  && apt-get install -y --no-install-recommends nodejs  && rm -rf /var/lib/apt/lists/*
```

---

## 3. devcontainer.json
以下を `.devcontainer/devcontainer.json` として保存してください。

```jsonc
{
  "name": "ml-full (pytorch25.04-py3)",
  "build": {
    "dockerfile": "Dockerfile"
  },
  "mounts": [
    "source=${localEnv:HOME}/data,target=/data,type=bind"
  ],
  "runArgs": [
    "-v",
    "${localEnv:HOME}/.gitconfig:/etc/gitconfig:ro"
  ],
  "customizations": {
    "vscode": {
      "extensions": [
        "GitHub.copilot",
        "GitHub.copilot-chat",
        "ms-toolsai.jupyter",
        "ms-python.python",
        "ms-python.black-formatter",
        "ms-python.isort",
        "ms-python.flake8"
      ]
    }
  },
  "remoteUser": "ubuntu"
}
```

---

## 4. Copilot & Copilot Chat のセットアップ

### 4.1 サインイン確認
- VS Code 左下のアカウントアイコンをクリック  
- `GitHub.com – <ユーザー名>` が表示されていれば連携済みです  
- コマンドパレット（`Ctrl+Shift+P` / `⌘+Shift+P`）→ `GitHub: Show GitHub Authentication` でも確認可能

### 4.2 Copilot Chat パネル表示
- コマンドパレット → `Copilot Chat: Open Chat` を実行  
- サイドバー下部の「…」→「Copilot Chat」にチェックを入れて表示

### 4.3 無料枠・課金
- Copilot Chat は Copilot 個人プランに含まれるため、追加課金は発生しません

---

## 5. Jupyter の動作確認

### 5.1 サーバー起動（手動）
```bash
jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser
# または
jupyter lab --ip=0.0.0.0 --port=8888 --no-browser
```

### 5.2 VS Code 自動起動設定
- コマンドパレット → `Jupyter: Specify Local or Remote Jupyter Server for Connections` → `Default (Local)`

### 5.3 セル実行
- **Shift+Enter** または **Ctrl+Enter** で実行  
- キーバインド設定を「キーボード ショートカット」で確認 (`notebook.cell.execute`)

---

## 6. 発生した問題と対処法

- **拡張機能が表示されない**  
  → `.devcontainer.json` の `extensions` 設定を確認し、コンテナをRebuild

- **Copilot Chat パネルに何も表示されない**  
  → 初回ウェルカムメッセージのみ表示される仕様。「Ask Copilot」から質問可能

- **セル実行ができない**  
  → Jupyter サーバーが起動していない  
  → 手動または自動起動設定でサーバーを立ち上げ、再度セルを実行

---

以上が Week0 の GitHub Copilot 導入ガイドです。
