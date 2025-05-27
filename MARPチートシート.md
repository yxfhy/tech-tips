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
.mdファイルの先頭でMARP有効化のおまじないを記入し、あとは普通にMDを書く
```
---
marp: true
---
# THIS IS MY FIRST MARPSLIDE
## Section 1
```



  
