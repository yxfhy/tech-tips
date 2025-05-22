#!/bin/bash

# Node.js（推奨: LTS版）
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs

# Marp CLI
sudo npm install -g @marp-team/marp-cli
