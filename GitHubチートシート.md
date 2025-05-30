# サーバーからファイルをリポジトリに自動追加

##  GitHub でトークンを発行
1. Settings → Developer settings → Personal access tokens → Fine-grained tokens → Generate new token

2. Token name と有効期限（例 90 日）を入力

3. Repository access は Only select repositories を選び、メモ専用リポジトリだけチェック

3. Repository permissions で Contents → Read and write を選択（他は No access のまま）

4. Generate token を押し、表示された文字列をコピー（再表示不可）

## 実装

サーバーの 環境変数 に
```
GITHUB_OWNER=ユーザー名
GITHUB_MEMO_REPO=メモ用リポジトリ名
GITHUB_TOKEN=xxxxxxxxxxxxxxxx
GITHUB_BRANCH=main       # 既定ブランチ名
```

例えばgithub_push.pyに

```
import base64, datetime, os
import httpx
from fastapi import APIRouter, HTTPException, Depends
from utils.db import get_memo_by_id   # 既存の取得関数を想定

router = APIRouter(prefix="/api")

GITHUB_API = "https://api.github.com"

def github_headers():
    return {
        "Authorization": f"Bearer {os.environ['GITHUB_TOKEN']}",
        "Accept": "application/vnd.github+json"
    }

@router.post("/memos/{memo_id}/push")
async def push_memo(memo_id: int):
    memo = get_memo_by_id(memo_id)
    if not memo:
        raise HTTPException(404, "memo not found")

    owner  = os.environ["GITHUB_OWNER"]
    repo   = os.environ["GITHUB_MEMO_REPO"]
    branch = os.getenv("GITHUB_BRANCH", "main")
    path   = f"{memo.title or 'memo'}-{memo_id}.md"
    msg    = f"Add memo {memo_id} ({datetime.datetime.now().isoformat()})"
    content_b64 = base64.b64encode(memo.content.encode()).decode()

    async with httpx.AsyncClient() as client:
        # 既存ファイルの SHA を取得（無ければ 404）
        r = await client.get(f"{GITHUB_API}/repos/{owner}/{repo}/contents/{path}?ref={branch}",
                             headers=github_headers())
        data = {"message": msg, "content": content_b64, "branch": branch}
        if r.status_code == 200:
            data["sha"] = r.json()["sha"]     # 更新
        # 作成／更新
        r2 = await client.put(f"{GITHUB_API}/repos/{owner}/{repo}/contents/{path}",
                              headers=github_headers(), json=data)
        if r2.status_code not in (200, 201):
            raise HTTPException(r2.status_code, r2.text)

    return {"status": "ok"}

```
