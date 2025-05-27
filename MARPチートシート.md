# INSTALL
ubuntuでは下記の要領でインストール。WindowsではVSCodeのプラグインのみのインストールでよい。
```
sudo apt update

# Node.js（推奨: LTS版）
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

# Marp CLI
sudo npm install -g @marp-team/marp-cli

#  marp to pptx need this
sudo apt install -y chromium-browser
sudo apt install fonts-noto-cjk
```

さらにVSCodeで`Marp for VS Code`をインストール  


# 編集可能なpptxを生成する設定
`Pptx: Editable`を`on`

さらに[LibreOfficeをインストール](https://www.libreoffice.org/download/download-libreoffice/)

# 使い方
[ここが分かりやすい](https://qiita.com/pocket8137/items/27ede821e59c12a1b222)　　  
.mdファイルの先頭でMARP有効化のおまじないを記入し、あとは普通にMDを書く
```
---
marp: true
style: |
  body {
    font-family: "メイリオ", "Meiryo", sans-serif;
  }
  h1, h2, h3, p, li {
    font-family: "メイリオ", "Meiryo", sans-serif;
  }
  img.custom-size {
    width: 150px; /* 幅を150pxに設定 */
    height: auto; /* 高さは自動調整 */
  }
---
  <!-- paginate: true --> /* ページ番号を自動でつける */
  <!-- footer: ○○株式会社 -->　/* フッター */


  *ディレクティブ名: ディレクティブの値

# THIS IS MY TITLE SLIDE

---

# BACKGROUND
```



  
