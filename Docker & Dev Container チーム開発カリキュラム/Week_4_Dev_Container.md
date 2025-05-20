# Week 4 Dev Container レッスンまとめ

## 目標
- VS Code Dev Containers を使い、Docker CLI を直接叩かずに「コンテナ内」で開発作業やテストができる環境をワンクリックで用意する。

## 背景と登場理由
- **“Works on My Machine” 問題**  
  開発者ごとに環境差分があり、動作再現性に課題があった。
- **コンテナ技術の導入と限界**  
  Docker イメージ自体は共通化できるものの、CLI 操作や IDE 連携が煩雑だった。
- **Dev Containers の役割**  
  `devcontainer.json` と拡張機能で、ビルド→起動→アタッチを VS Code 上で自動化し、全員が同一環境で作業可能にする。
- **要するに**
  コンテナの中に入ったみたいな感覚で開発できる
  
## ハンズオン手順

### 1. フォルダ作成
```bash
mkdir sample-devcontainer && cd sample-devcontainer
```

### 2. アプリとテスト配置
```bash
cat > main.py <<'PY'
def add(a: int, b: int) -> int:
    return a + b
PY

mkdir tests
cat > tests/test_main.py <<'PY'
from main import add

def test_add():
    assert add(1, 2) == 3
PY
```

### 3. `.devcontainer/Dockerfile`
```Dockerfile
FROM mcr.microsoft.com/vscode/devcontainers/python:3.11
RUN pip3 install --no-cache-dir pytest pre-commit
```

### 4. `.devcontainer/devcontainer.json`
```json
{
  "name": "sample-python-dev",
  "build": { "context": "..", "dockerfile": "Dockerfile" },
  "features": {
    "ghcr.io/devcontainers/features/git:1": {},
    "ghcr.io/devcontainers/features/python:1": { "version": "3.11" }
  },
  "settings": {
    "terminal.integrated.defaultProfile.linux": "bash"
  },
  "extensions": [
    "ms-python.python",
    "ms-python.vscode-pylance"
  ],
  "forwardPorts": [8000],
  "postCreateCommand": "pre-commit install",
  "remoteUser": "vscode"
}
```

### 5. `.pre-commit-config.yaml`
```yaml
repos:
  - repo: https://github.com/psf/black
    rev: 24.3.0
    hooks:
      - id: black
  - repo: https://github.com/pycqa/isort
    rev: 5.13.2
    hooks:
      - id: isort
  - repo: https://github.com/pycqa/flake8
    rev: 7.0.0
    hooks:
      - id: flake8
```

### 6. コンテナ起動とテスト
1. VS Code 左下の「開発コンテナー」→「コンテナーで再度開く」を実行  
2. バックグラウンドで Docker イメージのビルドログが流れる  
3. ターミナルでテスト実行:
    ```bash
    pytest -q
    ```

### 7. pre-commit 動作確認
1. プロジェクトルートに `.pre-commit-config.yaml` を置く  
2. コンテナ内で
    ```bash
    pre-commit install
    ```
3. 変更をステージングしてコミット:
    ```bash
    git add .
    git commit -m "pre-commit 動作確認"
    ```
   Black／isort／flake8 が自動で動作することを確認。

## 詰まったところと解法

### ヒアドキュメント
- `cat > main.py <<'PY'` から `PY` までをまとめてファイルに書き込む仕組み。

### pytest
- Python テストフレームワーク。`-q` は簡潔モード。

### フィクスチャとカバレッジ／マーカー
- `@pytest.fixture` で前処理・後処理をまとめる。  
- `pytest --cov=パッケージ名` でカバレッジ測定。  
- `@pytest.mark.slow` と `pytest -m slow` でタグ付け実行。

### ModuleNotFoundError と PYTHONPATH
- テスト実行時のカレントディレクトリが `tests/` になっていると `main` モジュールが見つからない。  
- プロジェクトルートで `pytest -q` 実行、または
  ```bash
  export PYTHONPATH="${PWD}"
  pytest -q
  ```
  で解決。

### `.pre-commit-config.yaml` の配置
- リポジトリ直下に置かないと検出されないので、`.devcontainer/` の外へ移動。

### Git の基本操作
- `git add` でステージング、`git commit` で確定。新規ファイルは必ず `add` が必要。  
- `git commit -am` で既存ファイルの変更を自動ステージング。

### VS Code の警告対応
- Unstaged files detected: ソース管理ビューまたは `git add .` でステージング。

### コンテナの抜け方・再アタッチ
- 左下の「開発コンテナー」→「フォルダーをローカルで再度開く」。  
- 再度入るには「コンテナーで再度開く」または「実行中のコンテナーにアタッチ」。

### 設定ファイル作成の効率化
- コマンドパレットで「Dev Containers: Add Dev Container Configuration Files…」を実行し、雛形を自動生成。

### python main.py
- `pytest` とは別に、簡易動作確認として `python main.py` でも実行可能。

