# VS Code Dev Container で “jovyan” エラーが出る原因と対策メモ

## 概要
VS Code で **`devcontainer.json`** に `remoteUser` を明示していないのに、  
コンテナ起動ログに  

```
Start: Run in container: (command -v getent >/dev/null 2>&1 && getent passwd 'jovyan' ...
```  

と表示される現象の原因と恒久対策を整理。

---

## 発生条件
1. 以前 **Jupyter Docker Stacks** 系イメージ（既定ユーザー=`jovyan`）を使ったことがある  
2. 新しいプロジェクトでは **まったく別のベースイメージ**（例 `mcr.microsoft.com/devcontainers/base:jammy`）を使う  
3. それでも VS Code が残存設定やキャッシュを参照し、`jovyan` を探す

---

## 原因
| No. | 説明 |
| --- | --- |
| **A** | **古い devcontainer コンテナ／イメージがホストに残存**<br>VS Code が “Reuse” を選択し、前回のユーザー設定を引き継いでしまう |
| **B** | **devcontainer ラベル／feature が `LABEL dev.containers.user=jovyan` を注入**<br>マルチステージビルドや自動生成された Dockerfile によく紛れ込む |
| **C** | **シェルの環境変数 `DEVCONTAINER_USER` が設定済み**<br>開発環境ドットファイルで上書きされるケース |

---

## 対策手順

### 1 残存コンテナ・イメージの完全削除
```bash
# devcontainer 用で残っているコンテナを Stop & Remove
docker ps -a --filter "label=devcontainer.local_folder" -q | xargs -r docker rm -f

# 不要イメージもまとめて削除（任意）
docker system prune -af
```

### 2 キャッシュリセット
```bash
# VS Code Dev Containers 拡張のキャッシュ
rm -rf ~/.vscode-server/data/User/globalStorage/devcontainers
```

### 3 `remoteUser` を明示設定
`mcr.microsoft.com/devcontainers/base:jammy` には **`vscode`**（UID=1000）が事前作成済み。

```jsonc
{
  "remoteUser": "vscode"
}
```

### 4 再ビルド
VS Code コマンドパレット → **“Dev Containers: Rebuild and Reopen in Container”**

---

## 再発防止チェックリスト

- 新規プロジェクト作成時は **`remoteUser` を必ず書く**  
  （デフォルトユーザーを明示したほうがトラブルが少ない）
- Dockerfile／features で **`LABEL dev.containers.user`** が紛れ込んでいないか grep
- システム全体の **環境変数 `DEVCONTAINER_USER`** を設定しない
- 異なるイメージへ切り替えるときは **Rebuild** を徹底し、Reuse を避ける

---

## 参考コマンド集

```bash
# コンテナ内の現在ユーザー確認
whoami

# /etc/passwd に特定ユーザーがあるか
grep '^vscode:' /etc/passwd

# Dockerfile からラベルを抽出
docker history --no-trunc your-image | grep -i dev.containers.user
```

---

*Last updated: 2025-05-05 10:16:45 JST*
