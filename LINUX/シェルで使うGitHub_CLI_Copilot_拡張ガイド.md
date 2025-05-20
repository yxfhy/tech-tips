# GitHub CLI Copilot 拡張（gh-copilot）インストールと使用ガイド

## 前提条件
- GitHub アカウントをお持ちであること

## 1. GitHub CLI のインストール

### Ubuntu / Debian
```bash
sudo apt update
sudo apt install gh
```

### Snap
```bash
sudo snap install gh
```

### Windows (winget)
```powershell
winget install --id GitHub.cli
```

## 2. GitHub CLI でのログイン
```bash
gh auth login
```
- プロンプトに従ってブラウザ認証を行ってください。

## 3. Copilot CLI 拡張のインストール
```bash
gh extension install github/gh-copilot
```

## 4. 使用例

### コマンド提案
```bash
gh copilot suggest "how to unzip"
# → unzip file.zip
```

### コマンド説明
```bash
gh copilot explain "tar xvf archive.tar.gz"
# → コマンドの詳細な説明が表示されます
```

## 5. エイリアスの設定（任意）
```bash
echo 'alias copilot="gh copilot"' >> ~/.bashrc
echo 'alias suggest="gh copilot suggest"' >> ~/.bashrc
echo 'alias explain="gh copilot explain"' >> ~/.bashrc
source ~/.bashrc
```
