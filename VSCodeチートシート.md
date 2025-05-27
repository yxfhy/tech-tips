


# スニペット
Ctrl+Shift+P → Snippets: Configure Snippets →　global.code-snippets　に下記を追加で`;date`と入力すると日付が挿入される
```json
{
  "Insert Today Date": {
    "prefix": ";date",
    "body": [
      "${CURRENT_YEAR}-${CURRENT_MONTH}-${CURRENT_DATE}"
    ],
    "description": "今日の日付を YYYY-MM-DD 形式で挿入"
  }
}
```

# 左ペインのエクスプローラから色んなファイルを開く
プラグインの`Open in External App`をインストール。 
## 開き方
エクスプローラで .ppt(x) を右クリック → Open in External App  
→ 既定アプリが PowerPoint に設定されていれば、そのまま PowerPoint が起動します。  
※ 既定アプリが別ソフトの場合は、Windows の「既定のアプリ」設定で PowerPoint を関連付けてください。  

# VSCodeでのリモートデバッグ設定
## 設定
### 1. tasks.json の設定
- `debug-uvicorn` タスクが `debugpy` を経由して Uvicorn サーバーを起動  
```json
{
  "label": "start-debug-server",
  "type": "process",
  "command": "python3",
  "args": [
      "-m",
      "debugpy",
      "--listen",
      "0.0.0.0:5678",
      "-m",
      "uvicorn",
              "app:app",
              "--reload",
              "--host",
              "0.0.0.0",
              "--port",
              "8000"
      ],
  "problemMatcher": [],
  "group": "build"
  }
```
### 2. launch.json の設定
"FastAPI Remote Debug"でデバッグすると、VSCode がポート `5678` でコンテナ内プロセス（`debugpy`）に接続  

```json
{
  "type": "python",
  "request": "attach",
  "name": "FastAPI Remote Debug",
  "port": 5678,
  "host": "localhost",
  "pathMappings": [
    {
      "localRoot": "${workspaceFolder}",
      "remoteRoot": "${workspaceFolder}"
    }
}
```
### 3. devcontainer.json のポート設定
- コンテナ起動時にホストとコンテナ間でポート `5678`（デバッグ用）と `8000`（HTTP）を紐付け  
- VSCode が自動でこれらのポートをフォワードし、ローカルホスト経由でアクセス可能に

```json
"runArgs": [
  "--publish", "5678:5678"
],
"forwardPorts": [
  5678,
  8000
]
```

## デバッグ手順
1. 初回に、ターミナル→タスクの実行で"start-debug-server"を実行させデバッグサーバーを立ち上げておく
2. あとはF5を"FastAPI Remote Debug"に割り当てておけば、毎回F5押下だけでデバッグ開始できる
3. もしサーバーが落ちていたら1でデバッグサーバーを再度立ち上げ








## デバッグが可能になる仕組み

1. **`tasks.json` のデバッグタスク起動**  
   
2. **`launch.json` のアタッチ設定**  
   - `preLaunchTask` で先に `debug-uvicorn` タスクを実行し、サーバー起動を保証

3. **`devcontainer.json` のポート公開・転送**  
   
