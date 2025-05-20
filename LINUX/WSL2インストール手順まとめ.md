# WSL2 インストール手順まとめ

## 1. 前提条件

- Windows 10 バージョン 2004 以降、または Windows 11
- 管理者権限での PowerShell 実行が可能であること

## 2. WSL の有効化

1. 管理者権限で PowerShell を起動
2. 以下を実行して WSL と仮想マシンプラットフォーム機能を有効化
   ```powershell
   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
   ```
3. システムを再起動

## 3. WSL2 の既定化

- 再起動後、PowerShell で以下を実行して WSL2 を既定のバージョンに設定
  ```powershell
  wsl --set-default-version 2
  ```

## 4. Linux ディストリビューションのインストール

- Microsoft Store から「Ubuntu」など好みのディストリをインストール
- または PowerShell で一括インストール
  ```powershell
  wsl --install -d Ubuntu
  ```

## 5. 初回起動とユーザー設定

1. スタートメニューの「Ubuntu」を起動
2. ユーザー名とパスワードを設定

## 6. パッケージアップデート

```bash
sudo apt update && sudo apt upgrade -y
```

## 7. 便利な設定・拡張

- Windows ファイルシステム（例: `/mnt/c`）へのアクセス確認
- Docker Desktop の WSL インテグレーションを有効化
- zsh や tmux、git などのツールをインストール
  ```bash
sudo apt install -y zsh git tmux
chsh -s $(which zsh)
```

## 8. トラブルシューティング

- インストールエラー時は PowerShell を管理者権限で再度実行
- `wsl --status` で現在のバージョンや設定を確認
- Windows Update や再起動を適宜実施

---

以上で WSL2 の導入と基本設定は完了です。快適な Linux 開発環境をお楽しみくださいませ。

