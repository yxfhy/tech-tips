#!/bin/bash

# 環境構築スクリプト


sudo apt update

# Node.js（推奨: LTS版）
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

# Marp CLI
sudo npm install -g @marp-team/marp-cli

#  marp to pptx need this
sudo apt install -y chromium-browser
sudo apt install fonts-noto-cjk



