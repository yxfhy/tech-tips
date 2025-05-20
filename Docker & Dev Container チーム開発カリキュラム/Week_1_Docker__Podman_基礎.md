# Docker Week 1 完全総まとめ

## 1. インストール＆起動トラブルシュート
- **dockerコマンド未認識**  
  - 原因：Docker Desktopが未インストール  
  - 対処：公式サイトからWindows版をダウンロード＆インストール  
- **Docker Desktop起動忘れ**  
  - エラー：「pipe/dockerDesktopLinuxEngine」が見つからない  
  - 対処：タスクトレイのクジラアイコンから起動、または自動起動を設定  
  - 自動起動有効時のメモリ消費：500MB～1GB程度  
  - 設定：Settings > General > Start Docker Desktop when you log in  
- **WSL2ディストリビューション上でdocker CLI不可**  
  - エラー：“invoke the docker CLI from the docker-desktop WSL2 distribution. This is not supported.”  
  - 対処1：Windows CMD/PowerShellから実行  
  - 対処2：WSL Integration設定でUbuntuなどにチェックを入れ「Apply & Restart」

## 2. WSL1 vs WSL2
- **WSL1**  
  - WindowsがLinuxシステムコールを翻訳するエミュレーション  
  - cgroup・namespaceなど一部機能非対応  
- **WSL2**  
  - 本物のLinuxカーネルを軽量VM(Hyper‑V)上で動作  
  - ほぼ全てのLinuxアプリとDockerがネイティブ動作  
  - ファイルI/O性能向上・互換性優先

### cgroup / namespace
- **cgroup**：CPUやメモリ使用量を制限・管理  
- **namespace**：プロセスに独立したファイルシステムやネットワーク空間を提供  

## 3. 基本Dockerコマンド実践
1. **バージョン確認**  
   ```bash
   docker version
   ```
2. **動作テスト**  
   ```bash
   docker run hello-world
   ```
3. **イメージ一覧**  
   ```bash
   docker images
   ```
4. **コンテナ一覧**  
   ```bash
   docker ps
   docker ps -a    # Exited状態も含む
   ```
5. **ログ確認**  
   ```bash
   docker logs <コンテナID>
   ```
6. **テスト用イメージでOS情報確認**  
   - Alpine:
     ```bash
     docker run --rm alpine cat /etc/os-release
     ```
   - Ubuntu:
     ```bash
     docker run --rm ubuntu cat /etc/os-release
     ```

## 4. 英語フレーズまとめ
- **What now?**  
  - 「これどうすればいい？」（短縮形）
- **Use WSL2**  
  - 設定項目「WSL 2 を使用する」の英語短縮
- **WSL2?**  
  - 「WSL2って？」の英語最短形

## 5. Q&Aハイライト
- **Q: 何しようとしてるの？**  
  - Alpineは軽量テスト用イメージ、コンテナ内のOS情報確認テストです。
- **Q: 本物のLinuxカーネルを軽量仮想マシンで直接動作？？**  
  - WSL2はHyper‑Vを使った軽量VM上でネイティブ実行です。
- **Q: BIOSの上にWindowsとLinuxがいる？**  
  - 実際はWindows起動後、Hyper‑VがLinux VMを立ち上げます。

---
*以上が今回の会話で学んだすべてを反映したまとめでございます。*
