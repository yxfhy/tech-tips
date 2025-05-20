# VSCode と WSL 連携ガイド

このドキュメントでは、本会話でご紹介した手順とポイントをまとめ、Windows版 Visual Studio Code（VSCode）と WSL（Windows Subsystem for Linux）をシームレスに連携させる方法をご案内します。

---

## 1. VSCode のインストール（Windows版）

1. [Visual Studio Code ダウンロードページ](https://code.visualstudio.com) から「Windows User Installer」を取得  
2. インストーラーを実行し、画面の指示に従ってインストール  

> ※ Anaconda 経由でのインストールは不要です。

---

## 2. Remote – WSL 拡張機能の有効化

1. VSCode 左サイドバーの拡張機能アイコンをクリック  
2. 検索欄に `Remote - WSL` または `WSL` と入力  
3. ペンギンアイコンの「WSL」（Remote – WSL）拡張の横にある「Install」を押す  
4. コマンドパレット（Ctrl+Shift+P）で「Remote-WSL: New Window」を実行  
   または WSL ターミナルで対象フォルダに移動後、`code .` を実行

---

## 3. VS Code Server の仕組み

- 初回接続時に WSL 側 `~/.vscode-server/bin/<バージョン>` に自動インストール  
- Windows の VSCode 本体は UI 担当、WSL 側でファイル操作や拡張機能が動作  
- 一度インストールすれば再利用され、不要なら `~/.vscode-server` フォルダを削除可能

---

## 4. `code` コマンドの設定

### 方法1: インストーラーで PATH に追加

1. VSCode インストーラーを再度実行  
2. 「Add to PATH (requires shell restart)」にチェック  
3. WSL ターミナルを再起動して `code` コマンドを利用

### 方法2: シンボリックリンクを手動で作成

```bash
sudo ln -s "/mnt/c/Users/<Windowsユーザー名>/AppData/Local/Programs/Microsoft VS Code/bin/code"   /usr/local/bin/code
```

### 方法3: `~/.bashrc` に PATH を追記

```bash
echo 'export PATH="$PATH:/mnt/c/Users/<Windowsユーザー名>/AppData/Local/Programs/Microsoft VS Code/bin"' >> ~/.bashrc
source ~/.bashrc
```

---

## 5. 日本語化（表示言語の設定）

1. 拡張機能ビューで `Japanese Language Pack for Visual Studio Code (Microsoft)` をインストール  
2. コマンドパレットで「Configure Display Language」を実行  
3. リストから `ja` を選択し、VSCode を再起動

---

## 6. Microsoft Copilot について

- **何か**: AI コードアシスタント機能で、コード補完やエラー修正支援、自然言語質問応答が可能  
- **請求**: 無料トライアル終了後、自動で有料プランに移行しないので安心  
- **普及率**: スタートアップや大手企業などで急速に導入が進んでおり、生産性向上に貢献

---

以上が本会話でご紹介した内容のまとめです。VSCode と WSL を活用して、より快適な Linux ベースの開発環境をお楽しみください！
