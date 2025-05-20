# 自宅PCリモートアクセス用 DuckDNS 設定ガイド  
*(最終更新 2025-04-29 00:27)*  

個人宅の Windows PC へ外出先から **リモート デスクトップ (RDP)** で接続する場合、プロバイダーによって変動する **グローバル IP アドレス** を追跡する必要があります。本ドキュメントでは、無料の **DuckDNS** と Windows 標準機能だけを利用し、  
- IP 変化を自動検知  
- ドメイン名 (例 `mypc.duckdns.org`) を常に最新 IP へ紐付け  

するまでを、**手順を飛ばさず丁寧に** 解説します。  

---

## 0. 事前準備チェックリスト
| ✔ | 項目 |
|---|------|
|   | Windows 11 / 10 (管理者アカウントを使用できる) |
|   | ルーターで **TCP 3389** を PC へポート転送済み<br>　┗ 外部ポートを 3390 などに変更しても可 |
|   | `C:\Scripts` フォルダーが存在 (無ければ作成) |
|   | PowerShell 実行ポリシーを変更する権限がある |

---

## 1. DuckDNS でサブドメインとトークンを取得
1. ブラウザーで **<https://www.duckdns.org>** を開く  
2. **GitHub / Google** などでログイン  
3. 画面上部 **Domains** 欄に希望の名前 (例 `mypc`) を入力 → **add domain**  
4. ページ最上部の青帯に  
   ```
   token  xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
   ```  
   が表示される → **コピーしてメモ**  
5. 動作確認 (URLを直接開くと OK が返る)  
   ```
   https://www.duckdns.org/update?domains=mypc&token=<token>
   ```

---

## 2. PowerShell スクリプトを配置
`C:\Scripts\duckdns-update.ps1` を新規作成し、下記を貼り付けます。  

```powershell
$domain = 'mypc'                       # DuckDNS サブドメイン
$token  = 'xxxxxxxx-xxxx-....'         # 取得したトークン
$url    = "https://www.duckdns.org/update?domains=$domain&token=$token&ip="

try {{
    $resp = Invoke-RestMethod $url -TimeoutSec 10
    "$(Get-Date -UFormat '%Y-%m-%d %H:%M:%S') $resp" |
        Out-File "$PSScriptRoot\duckdns.log" -Append
}} catch {{
    "$(Get-Date -UFormat '%Y-%m-%d %H:%M:%S') ERROR $_" |
        Out-File "$PSScriptRoot\duckdns.log" -Append
}}
```

> `ip=` を空にすることで **アクセス元アドレスを自動取得** させています。  

---

## 3. PowerShell の実行ポリシーを緩和
管理者 PowerShell を開いて次を実行 → `Y` で確定。  

```powershell
Set-ExecutionPolicy RemoteSigned -Scope LocalMachine
```

---

## 4. タスク スケジューラに登録 (詳細手順)

### 4‑1 タスクの基本情報
| 項目 | 設定値 |
|------|--------|
| 名前 | **DuckDNS IP updater** |
| ユーザー | **NT AUTHORITY\SYSTEM** (後述の操作で設定) |
| 最上位の特権で実行 | ✔ |
| 構成 | **Windows 10** (Windows 11 専用は未掲載) |

#### NT AUTHORITY\SYSTEM に切り替える（推奨）
タスクを編集 → ［全般］タブ → **［ユーザーまたはグループの変更］** をクリック。  
入力欄に  

```
SYSTEM
```  

と打ち込み、［名前の確認］→ **OK**。  

「**最上位の特権で実行する**」 にチェック。  

そのまま［OK］で保存（パスワード入力は不要）。  

この方法ならパスワード管理が不要で確実に動きます。

### 4‑2 トリガー
1. **新規** → **起動時**  
2. **新規** → **ログオン時**  
3. **新規** → **毎日**  
   * 開始時刻: 任意 (例 00:00)  
   * **繰り返し間隔: １時間（１５分など短すぎるとduck側のDNS更新時間中にアクセスできないことが増える可能性があるため）**  
   * 継続時間: **無期限**

### 4‑3 操作
| 項目 | 値 |
|------|----|
| プログラム | `powershell.exe` |
| 引数 | `-ExecutionPolicy Bypass -File "C:\Scripts\duckdns-update.ps1"` |

---

## 5. 動作確認
1. タスク一覧で **右クリック → 実行**  
2. `C:\Scripts\duckdns.log` に `OK` が追記される  
3. DuckDNS 管理画面 **changed** 列の時刻が更新される  
4. 外部ネットワークから  
   ```
   mstsc /v:mypc.duckdns.org:3389
   ```  
   で RDP 接続できれば完了

---

## 6. つまづきポイント & 解決策

| 症状 | 解決策 |
|------|--------|
| トークンが見つからない | ページ最上部の青帯を確認。非表示時はログインし直す |
| `Set-ExecutionPolicy` で警告 | `Y` または `A` で続行 (自作スクリプトのため安全) |
| タスク保存エラー「ユーザー／パスが不正」 | SYSTEM に変更 または ローカル管理者＋正しい PW |
| 「ユーザーまたはグループの変更」ボタンが無い | ウィンドウを横に広げる / スケジューラを管理者で起動 |
| 構成に Windows 11 が無い | Windows 10 を選択で OK |
| IP が更新されない | `duckdns.log` と DuckDNS の **changed** 列を確認 |

---

## Appendix – RDP セキュリティ強化メモ
* 強力なパスワード + **NLA (ネットワーク レベル認証)** を必ず有効化  
* 公開ポート番号を 3389 から変更 (例 3390)  
* ファイアウォールで接続元 IP を制限できるなら限定する  

---

> **備考:** 本手順は 2025‑04 時点の仕様に基づきます。DuckDNS UI 変更等あれば適宜読み替えてください.
