# Docker Desktop - Ubuntu WSL 統合復旧手順

1. **Restart the WSL integration**
   - ダイアログの「Restart the WSL integration」をクリック

2. **WSL 全体を一度シャットダウンして再起動**
   ```powershell
   wsl --shutdown
   ```
   - Windowsを再起動するか `wsl` コマンドでWSLを再起動  
   - Docker Desktopを起動

3. **Ubuntu WSL が Version 2 かを確認**
   ```powershell
   wsl -l -v
   ```
   - VERSION が 2 でない場合:
   ```powershell
   wsl --set-version Ubuntu 2
   ```

4. **Docker Desktop で WSL 統合を再登録**
   1. Docker Desktop → Settings → Resources → WSL Integration  
   2. Ubuntu のチェックを外して **Apply & restart**  
   3. 再度 Ubuntu にチェックして **Apply & restart**

5. **まだ解決しない場合**
   - **A**: `docker-desktop` ディストリビューションを再登録  
     ```powershell
     wsl --unregister docker-desktop
     ```
     Docker Desktopを起動すると再生成されます。
   - **B**: Ubuntuアプリを「修復」 (設定→アプリ→Ubuntu→修復)  
   - **C**: Docker Desktopをアップデート／再インストール  
   - **D**: 「Gather diagnostics」を実行し、公式フォーラムやGitHub issueへログを添付

---

**補足**
- ディスク容量不足やセキュリティソフトの干渉に注意。空き容量を確保し、リアルタイム保護を一時オフ。  
- WindowsやWSL kernelの更新も確認:
  ```powershell
  wsl --update
  ```
