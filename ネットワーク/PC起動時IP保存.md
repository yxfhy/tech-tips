# PC起動時IP保存

## 1 PowerShell スクリプトを用意します

1. **メモ帳**を開き、下記をそのまま貼り付けてください。

```powershell
# GetGlobalIP.ps1
$dst = "$env:USERPROFILE\OneDrive\Documents\global_ip.txt"

# 取得を3回までリトライ（ネット接続が遅い直後でも対応）
for ($i = 0; $i -lt 3; $i++) {
    try {
        $ip = Invoke-RestMethod -Uri "https://api.ipify.org"
        if ($ip) { break }
    } catch { Start-Sleep -Seconds 5 }
}

if ($ip) {
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    "$timestamp`t$ip" | Out-File -FilePath $dst -Encoding UTF8 -Append
}
```

2. **名前を付けて保存**
- ファイル名: `GetGlobalIP.ps1`
- 文字コード: **UTF-8**
- 保存先: 例として `C:\Scripts` を作成し、そこへ保存

## 2 スタートアップ時に実行させる設定

### 方法 A: スタートアップ フォルダーにショートカット（手軽）

1. `Win + R` → `shell:startup` と入力し **Enter**  
   スタートアップ フォルダーが開きます。  
2. 右クリック → **新規作成 > ショートカット**  
   - 「項目の場所」へ次を入力:  
     ```
     powershell.exe -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\GetGlobalIP.ps1"
     ```  
3. 名前はお好みで（例: _GetGlobalIP_）

### 方法 B: タスク スケジューラ（電源投入直後に確実に）

1. **タスク スケジューラ**を開き、右側の「基本タスクの作成…」をクリック。  
2. 名前: 例「Write Global IP」。  
3. **トリガー**:  
   - 「コンピューターの起動時」  
   - 「遅延時間 30秒」程度に設定  
4. **操作**:  
   - 「プログラムの開始」  
   - プログラム/スクリプト: `powershell.exe`  
   - 引数:  
     ```
     -NoProfile -ExecutionPolicy Bypass -File "C:\Scripts\GetGlobalIP.ps1"
     ```  
5. 「ユーザーがログオンしているかどうかにかかわらず実行」にチェック、  
   「最上位の特権で実行」にもチェック。  
6. 完了後、タスクを右クリック → **実行**し、正常に `global_ip.txt` が更新されることを確認。

## 3 ファイルの確認

`global_ip.txt` には以下の形式で追記されます（タブ区切り）:

```
2025-05-14 09:10:05	123.45.67.89
```

OneDrive の同期が完了すれば、スマートフォン等からも確認可能です。

## 4 うまく動かないときの確認点

1. **実行ポリシー**  
   管理者 PowerShell で `Get-ExecutionPolicy` が `Restricted` の場合、  
   タスクやショートカットの引数に `-ExecutionPolicy Bypass` を付けたことを再確認。  
2. **通信遮断**  
   `https://api.ipify.org` がブロックされる場合、  
   `https://ifconfig.me/ip` などに書き換えてください。  
3. **OneDrive 同期競合**  
   同期待ちの青い矢印が長時間表示される場合、  
   OneDrive 設定 → 「ファイル オンデマンド」で状態を確認してください。  
