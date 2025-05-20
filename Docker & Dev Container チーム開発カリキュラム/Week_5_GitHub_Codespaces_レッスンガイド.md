# Week 5: GitHub Codespaces レッスンガイド

## 目標 (Learning Goals)
- ブラウザだけでフル機能の開発環境を立ち上げる  
- 低スペック端末でも同一環境を再現し、Pull Request を出せるようにする  
- devcontainer.json を使った自動セットアップとテスト実行を理解する  

## 前提：Week 4 プロジェクトを GitHub に公開
1. **リモートリポジトリ作成**  
   - GitHub 上でリポジトリを作成 (`week4-project` など)  
2. **ローカルリポジトリ初期化 & プッシュ**  
   ```bash
   cd /path/to/week4-project
   git init
   git add .
   git commit -m "Initial commit for Week 4 project"
   git branch -M main
   git remote add origin https://github.com/<username>/week4-project.git
   git push -u origin main
   ```
3. **認証方法**  
   - **Personal Access Token (PAT)** を作成し、`repo` スコープを付与  
   - または **SSH 鍵**を登録して SSH URL でプッシュ  

## GitHub Codespaces の仕組み
- `.devcontainer/` フォルダの Docker イメージ上に開発環境を自動構築  
- ブラウザ版 VS Code Web、またはローカル VS Code から接続可能  
- port forwarding 対応（例：8000 番）  

## Codespace の起動方法
- **ブラウザ**  
  1. リポジトリ画面 → **Code** → **Codespaces** → **Create codespace on main**  
- **GitHub CLI**  
   ```bash
   gh auth login
   gh codespace create --repo <username>/week4-project
   gh codespace list
   gh codespace code -c <CODESPACE_NAME>
   ```

## devcontainer.json のカスタマイズ
- `.devcontainer/devcontainer.json` を編集  
  ```jsonc
  {
    "forwardPorts": [8000],
    "postCreateCommand": "pre-commit install && pytest -q | tee pytest-report.txt",
    "postStartCommand": "pytest -q | tee pytest-report.txt",
    "containerEnv": {
      "PYTHONPATH": "/workspaces/week4-project"
    },
    "remoteUser": "vscode"
  }
  ```
- **postCreateCommand**：コンテナ作成直後に実行  
- **postStartCommand**：起動ごとに実行  
- **containerEnv**：環境変数設定（PYTHONPATH など）  

## コンテナの再構築 (Rebuild)
- **Rebuild** (キャッシュ有効) vs **Full Rebuild** (キャッシュクリア)  
- ステータスバーの「Dev Containers」アイコン、または `Ctrl+Shift+P` → **Dev Containers: Rebuild Container** で実行  
- 接続が一時切断された後、自動または手動で再接続  

## テストの自動実行確認
- `postCreateCommand` によって `pre-commit install` と `pytest` が実行  
- ログはターミナル上部をスクロールして確認  
- 標準出力が見えない場合は、`tee pytest-report.txt` でレポートを生成  

## 即席 Web サーバ起動例
```bash
echo '<!DOCTYPE html><html><body><h1>Hello, Codespaces!</h1></body></html>' > index.html
python3 -m http.server 8000
```
- `http.server` モジュールで簡易 static ファイルサーバを起動  

## Git フローと Pull Request
1. **新規ブランチ作成＆プッシュ**  
   ```bash
   git checkout -b feat/devcontainer-setup
   git push -u origin feat/devcontainer-setup
   ```
2. **PR 作成 & マージ**  
   - GitHub 上でレビューなしでも **Merge pull request** 可能  
   - ブランチ保護ルールは未設定なら制限なし  
   - 必要な場合は Settings → Branches → Add rule で保護ルールを設定  

## チェックポイント
- `pytest` が自動で動き、`pytest-report.txt` が生成されている  
- Ports タブからポート 8000 へアクセスして確認（Web アプリが無い場合は即席サーバ）  
- Pull Request を作成し、マージまで完了

---

以上で **Week 5: GitHub Codespaces** の内容が再現可能です。

## Codespace の停止と削除

### 1. Codespace の停止 (Stop)
- **GitHub UI**  
  1. リポジトリ画面 → **Code** → **Codespaces**  
  2. アクティブな Codespace の右側メニュー（…） → **Stop codespace** をクリック  
- **GitHub CLI**  
  ```bash
  # 特定の Codespace を停止
  gh codespace stop --codespace <CODESPACE_NAME>
  ```

### 2. Codespace の削除 (Delete)
- **GitHub UI**  
  1. **Codespaces** 一覧画面 → ... → **Delete codespace**  
  2. 確認ダイアログで **Delete** をクリック  
- **GitHub CLI**  
  ```bash
  # Codespace を削除
  gh codespace delete --codespace <CODESPACE_NAME>
  ```

> 💡 **自動削除**: 7日間利用がないと自動的に削除され、ストレージコストを抑制します。

