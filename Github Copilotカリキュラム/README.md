
# GitHub Copilot & VS Code AI 活用カリキュラム

追記：[公式のガイド](https://docs.github.com/ja/copilot)も参考に

## 目的
- **3年間のブランク**を取り戻し、最新の AI 補助コーディングを自在に使えるようにする  
- GitHub Copilot / Copilot Chat を VS Code で使いこなし、Jupyter ノートブックにも活用する  
- Docker + Dev Container 環境を前提に、安全に API キーを管理しながら開発を高速化する  

---
## Week 0 : 前提環境セットアップ
1. **GitHub Copilot 個人プランの有効化**  
   30 日無料 → 月額 39 USD または年額 390 USD。学生 / OSS 貢献者は無料枠あり。  
2. **VS Code 最新版のインストール**  
   - 拡張機能「*GitHub Copilot*」「*GitHub Copilot Chat*」「*Jupyter*」を追加。  
   - `github.copilot.enable` を `true`、必要なら `github.copilot.advanced` を編集して既定モデルを GPT‑4o に設定。  
3. **言語ランタイム**  
   - Node.js ≥ 18、Python ≥ 3.10 を推奨。  
4. **SSH key / GPG key を整理**し、GitHub への push を確認。  
5. **Docker Desktop + Dev Container 拡張**の確認（すでに導入済みならスキップ）。  

---
## Week 1 : Copilot Autocomplete の基本
1. `Tab` 受け入れ / `Esc` 拒否で候補を試す。  
2. **コメントドリブン生成**: `// 与えられた配列を昇順ソート` → 実装候補を生成。  
3. **ペアプロ**: Copilot Chat パネルを開き `/explain` `/fix` を試す。  
4. **設定**: `Alt+\\` で「次の候補を表示」。  

### チャレンジ  
- FizzBuzz、JSON → CSV 変換など小問題を Copilot に書かせ、読んで手直しする。  

---
## Week 2 : 効果的なプロンプト設計
1. 「入力・出力の例」をコメントで提示して誘導。  
2. LL(英語)・正規表現など **意図を詳細に書くほど品質↑**。  
3. `/** TODO: edge 例外を考慮してリファクタ */` → フィードバックを得る。  

---
## Week 3 : リファクタリング & ドキュメント
1. Copilot Chat の `/refactor` コマンドで関数分割。  
2. `/docs` で JSDoc / docstring を自動生成。  
3. Copilot Labs パネル → *Refactor Selection* で構造化。  

---
## Week 4 : テスト生成 & デバッグ
1. `/tests` でユニットテスト雛形。  
2. VS Code デバッグ中、エラー行を選択して `/explain`。  
3. 生成テストを pytest / jest で実行して失敗‑原因を分析。  

---
## Week 5 : Jupyter Notebook × Copilot
1. VS Code で `.ipynb` を開き **コードセル内でも Copilot 候補**。  
2. Copilot Chat `/newNotebook` で新規ノート提案を生成（2025 Apr 機能）。  
3. **jupyter‑ai‑magics** を試す  

   ```bash
   pip install "jupyter-ai-magics==2.31.4" "openai==1.77.0"
   jupyter server extension enable --sys-prefix jupyter_ai
   ```  

   - ノートブック内で `%%ai gpt-4o` などを実行してセル内容を解説。  
4. **ノート → markdown** 自動生成や図表生成を活用。  

---
## Week 6 : Docker / Dev Container との統合
1. `.devcontainer/devcontainer.json` 例  

   ```jsonc
   {
     "image": "quay.io/jupyter/datascience-notebook:python-3.12",
     "features": {
       "ghcr.io/devcontainers/features/docker-outside-of-docker:1": {}
     },
     "postCreateCommand": "pip install 'jupyter-ai[openai]==2.31.4'",
     "forwardPorts": [8888],
     "env": {
       "OPENAI_API_KEY": "${{localEnv:OPENAI_API_KEY}}"
     }
   }
   ```  

2. VS Code で **「Dev Container: Reopen in Container」**。  
3. ノートブック共有は `jupyter-lab --ip 0.0.0.0` を Launch JSON に追加。  

---
## Week 7 : 実践プロジェクト
1. **FastAPI + SQLite** で簡易 REST API を作成。  
2. コードはコメント → Copilot 生成 → Chat で機能追加。  
3. pytest を `/tests` 生成、GitHub Actions で CI。  

---
## Week 8 : ベストプラクティス
1. **セキュリティ** : `.env` に API キー、リポジトリ公開時は `.gitignore`。  
2. **ライセンス** : 生成コードのライセンス確認 & 修正。  
3. **プライバシー** : Copilot へのコード送信ポリシーを社内規定と照合。  

---
## 付録 A : Copilot Chat コマンド早見表
| コマンド | 機能 |
|---------|------|
| `/explain` | 選択コードの説明 |
| `/fix` | バグ修正提案 |
| `/refactor` | リファクタ提案 |
| `/tests` | テスト雛形生成 |
| `/docs` | ドキュメント生成 |
| `/newNotebook` | 要件からノート作成 |

---
*Last update: 2025-05-04*
