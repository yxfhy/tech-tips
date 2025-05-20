# Windows 11でWSLのUbuntuをコマンドで起動・確認する方法まとめ

## 1. WSLとUbuntuの関係
- **WSL**（Windows Subsystem for Linux）は「Linuxを動かすための土台」。
- **Ubuntu**はWSLの上で動作する「Linuxディストリビューション」の一つ。
- WSLはUbuntu以外にも、DebianやAlpineなど様々なディストリを動かせる。

---

## 2. コマンドプロンプトから特定のUbuntuを一発起動する方法

### 例：`ub` でUbuntuを起動したい場合

1. `C:\Windows\ub.bat` というバッチファイルを作成し、以下を記述：
    ```bat
    @echo off
    "C:\Program Files\WSL\wsl.exe" --distribution-id {a8571cc4-221b-40db-bed7-f6bacb4d8d4c} --cd ~
    ```
2. バッチファイル名は**必ず「ub.bat」**にし、拡張子を間違えない（`ub.bat.txt` などにならないよう注意）。
3. コマンドプロンプト（cmd）で `ub` と入力すれば、指定したUbuntuが起動する。

---

## 3. **distribution-id の確認方法**

- **デスクトップやタスクバーにある「Ubuntu」アイコンを右クリックし、「プロパティ」を選択**
- 「リンク先」に  "C:\Program Files\WSL\wsl.exe" --distribution-id {GUID} --cd ~
のようなコマンドが書かれている
- この「リンク先」を参考にすれば、自分のUbuntuの distribution-id（GUID）を知ることができる

---

## 4. 拡張子を常に表示する方法

- エクスプローラーで「表示」→「表示」→「ファイル名拡張子」にチェックを入れる。

---

## 5. 起動したシェルがUbuntuか確認する方法

- シェルで以下のコマンドを実行：
  ```sh
  cat /etc/os-release
  ```
- 出力例：
  ```
  NAME="Ubuntu"
  PRETTY_NAME="Ubuntu 24.04.2 LTS"
  VERSION="24.04.2 LTS (Noble Numbat)"
  ```
- これで**Ubuntuであることを確認可能**。

---

## 6. その他のポイント

- バッチファイルは `C:\Windows\` に置けば、どこからでも呼び出せる（PATHが通っているため）。
- ファイル名の拡張子や場所、コマンド内容に注意。
- WSLとUbuntuは切り離して考える（WSL＝土台、Ubuntu＝中身）。

---


