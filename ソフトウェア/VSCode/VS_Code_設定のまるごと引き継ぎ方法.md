# VS Code 設定のまるごと引き継ぎ方法

VS Code の設定（スニペット含む）を新しい PC にまるごと引き継ぐ主な方法は以下の3つです。

## 1. 組み込み「Settings Sync」機能を使う

1. **同期元の PC** で  
   - `Ctrl+Shift+P` → **Settings Sync: Turn On** を実行  
   - Microsoft アカウントか GitHub アカウントでサインイン  
   - 同期したい項目（設定、拡張機能、スニペット、キー割当など）を選択  
2. **新しい PC** で同じ手順を実行すると、自動で設定が反映されます。  
3. 以降、設定変更は自動で両方のマシンに同期されます。

## 2. 拡張機能「Settings Sync」（Shan.code-settings-sync）を使う

1. **拡張機能** `Settings Sync` をインストール  
2. **同期元** で  
   - `Shift+Alt+U` で Gist トークンを指定しアップロード  
3. **新しい PC** で  
   - `Shift+Alt+D` → 同じトークンを入力しダウンロード  
4. 設定、スニペット、拡張一覧、キー割当などが一括で同期されます。

## 3. 手動で設定ファイルをコピーする

1. 以下フォルダを丸ごとコピー／バックアップ  
   - **Windows**: `%APPDATA%\Code\User\`  
   - **macOS**: `~/Library/Application Support/Code/User/`  
   - **Linux**: `~/.config/Code/User/`  
2. 新しい PC の同じ場所に上書きすれば、`settings.json` や `snippets/`、`keybindings.json` がすべて引き継がれます。  
3. 拡張機能は以下コマンドで一括インストール可能です：

    ```bash
    # 旧環境でエクスポート
    code --list-extensions > extensions.txt

    # 新環境で一括インストール
    cat extensions.txt | xargs -L 1 code --install-extension
    ```