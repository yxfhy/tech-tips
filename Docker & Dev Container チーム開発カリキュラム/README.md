Docker & Dev Container チーム開発カリキュラム
指導ガイド (for ChatGPT‑4o)

目的
----
ChatGPT‑4o が 8 週間でご主人さまに
「マルチプラットフォーム Docker + VS Code Dev Container 開発」を
習得させるための詳細な指導手順をまとめる。

各週の構成
==========
• Week n : テーマ
  – 目標 (Learning Goals)
  – レッスン内容 (What to Explain)
  – ハンズオン (Walk‑through)
  – 課題・チェックポイント (Homework & Checks)
  – 参考リソース (Resources)

Week 0: 準備
------------
目標
  * 受講条件とハード要件を確認
レッスン内容
  * Git / GitHub 基礎の再確認
  * 端末スペック調査コマンド紹介
ハンズオン
  * `git --version`, `python -V` を実行させる
課題
  * 空リポジトリを GitHub に作成
チェック
  * 4o は出力ログを確認し不足があれば指摘

Week 1: Docker / Podman 基礎
---------------------------
目標
  * イメージ／コンテナの概念を理解
レッスン内容
  * 用語解説、Docker Desktop または Podman インストール
ハンズオン
  * `docker run hello-world`
  * 基本コマンド: images, ps, exec, logs
課題
  * Alpine イメージで `/etc/os-release` を閲覧
チェック
  * コマンド結果を貼らせ、正しく表示されるか確認

Week 2: Dockerfile & Buildx
---------------------------
目標
  * 自作イメージを multi‑arch でビルド & Push
レッスン内容
  * 単一ステージ Dockerfile と Buildx セットアップ
ハンズオン
  * FastAPI 例を作成し Buildx で `linux/amd64,arm64` に push
課題
  * 別 PC で pull → 実行
チェック
  * `curl localhost:8000/docs` の戻り値チェック

Week 3: docker‑compose と GPU
-----------------------------
目標
  * CPU/GPU プロファイル切替
レッスン内容
  * compose.yml 書式、NVIDIA ランタイム
ハンズオン
  * `--profile gpu` で推論スクリプト
課題
  * 処理時間を CPU と比較し表にまとめる
チェック
  * 4o は結果をレビューしボトルネックをコメント

Week 4: VS Code Dev Container
-----------------------------
目標
  * `.devcontainer/` で開発環境を統一
レッスン内容
  * devcontainer.json 各キー解説
ハンズオン
  * Remote‑Containers で pytest 実行
課題
  * postCreateCommand に pre‑commit を追加
チェック
  * hook が動くかを確認し改善点提案

Week 5: GitHub Codespaces
-------------------------
目標
  * ブラウザ IDE で同一環境を提供
レッスン内容
  * 起動方法、料金試算
ハンズオン
  * Codespace で PR 作成
課題
  * 低スペック端末から PR を出す
チェック
  * Actions が通るかモニタリング

Week 6: micromamba + conda‑lock
------------------------------
目標
  * Docker 禁止環境への回避策
レッスン内容
  * environment.yml → conda‑lock フロー
ハンズオン
  * optional deps カテゴリ実演
課題
  * Windows 端末で lock ファイルから環境再現
チェック
  * `pytest` が全て成功するか

Week 7: GitHub Actions CI/CD
----------------------------
目標
  * 自動ビルド & テスト & レジストリ公開
レッスン内容
  * Matrix build, Secrets, Cron
ハンズオン
  * サンプルワークフローを作成
課題
  * Nightly GPU テストを追加
チェック
  * Artifact とログを確認して指摘

Week 8: 統合演習
---------------
目標
  * 新規サービスを 0→1 でデプロイ
レッスン内容
  * 要件定義 → コンテナ化 → CI → 本番環境
ハンズオン
  * チーム開発をシミュレーション
課題
  * Tech note を README にまとめる
チェック
  * 4o はコードレビューと振り返りレポート生成

付録
----
参考リンク
  * docs.docker.com
  * code.visualstudio.com/docs/devcontainers
  * github.com/docker/buildx
コマンド速習シート
  * build, run, compose, exec, logs, cp
"""

file_path = "/mnt/data/docker_devcontainer_curriculum_for_4o.txt"
with open(file_path, "w", encoding="utf-8") as f:
    f.write(content)

file_path
