# FastAPI の HTTPS 設定法メモ

このメモは、Lightsail 上で FastAPI を HTTPS 化する手順をまとめたものです。

---

## 前提条件

- Ubuntu 環境（例: Lightsail 7ドルプラン）
- ドメイン名: `yxfhy.duckdns.org`（DuckDNS で取得）
- Python3, pip3 がインストール済み
- Uvicorn で FastAPI アプリを HTTP で起動できる状態
- LightsailサーバーでHTTPS 443 ポート開放済

---

## 1. pip と Certbot-DuckDNS プラグインのインストール

1. pip3（Python パッケージ管理ツール）のインストール
   ```bash
   sudo apt update
   sudo apt install -y python3-pip
```

2. Certbot と DuckDNS プラグインを pip からインストール

   ```bash
   pip install certbot_dns_duckdns
   ```

   > ※ 公式ドキュメント（[https://pypi.org/project/certbot-dns-duckdns/）に従った方法です。](https://pypi.org/project/certbot-dns-duckdns/）に従った方法です。)

---

## 2. 証明書の取得

1. DuckDNS のトークンを確認（DuckDNS トップページで取得）

2. certbot コマンドのパスを確認して、先ほどpipでインストールしたcertbotを実行し、誤って別のバージョンを実行しないように注意

   ```bash
   which certbot
   # 例: /home/ubuntu/.local/bin/certbot
   ```

3. 以下のコマンドを実行して証明書を取得

   ```bash
   sudo /home/ubuntu/.local/bin/certbot certonly \
     --non-interactive \
     --agree-tos \
     --email メールアドレス \
     --preferred-challenges dns \
     --authenticator dns-duckdns \
     --dns-duckdns-token ダックDNSのトークン \
     --dns-duckdns-propagation-seconds 60 \
     -d "ドメイン名"
   ```

   * `--authenticator dns-duckdns`：DuckDNS プラグインを使用
   * `--dns-duckdns-token`：DuckDNS トークンを CLI で渡す
   * `--dns-duckdns-propagation-seconds 60`：TXT レコードの反映待ち時間（秒）

4. 成功すると以下のように表示される

   ```text
   Successfully received certificate.
   Certificate is saved at: /etc/letsencrypt/live/yxfhy.duckdns.org/fullchain.pem
   Key is saved at:         /etc/letsencrypt/live/yxfhy.duckdns.org/privkey.pem
   ```

---

## 3. Nginx の設定

1. 設定ファイル `/etc/nginx/conf.d/fastapi.conf` を作成（/etc/nginx/nginx.conf からincludeされていることを念のため確認したほうが良い）

   ```nginx
   server {
       listen 80;
       server_name yxfhy.duckdns.org;
       return 301 https://$host$request_uri;
   }

   server {
       listen 443 ssl http2;
       server_name yxfhy.duckdns.org;

       ssl_certificate     /etc/letsencrypt/live/yxfhy.duckdns.org/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/yxfhy.duckdns.org/privkey.pem;
       ssl_protocols       TLSv1.2 TLSv1.3;
       ssl_ciphers         HIGH:!aNULL:!MD5;

       location / {
           proxy_pass         http://127.0.0.1:8000;
           proxy_set_header   Host              $host;
           proxy_set_header   X-Real-IP         $remote_addr;
           proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
           proxy_set_header   X-Forwarded-Proto $scheme;
       }
   }
   ```

2. 設定のテストと再読み込み

   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```

---

## 4. 設定反映の確認

* ブラウザで `https://yxfhy.duckdns.org/` にアクセスし、鍵マークが表示される
* CLI で動作確認

  ```bash
  curl -vk https://yxfhy.duckdns.org/
  ```

---

## 5. 自動更新の設定

pip 版 Certbot には自動更新タイマーがないため、Cron を設定：

```bash
sudo crontab -e
```

```cron
0 3 * * * /usr/bin/env bash -lc 'PATH="$HOME/.local/bin:$PATH" certbot renew --quiet && nginx -s reload'
```

* 毎日 3:00 に証明書更新をチェックし、更新時に Nginx を再読み込み

---

## 備考

* 他の Certbot バージョンを誤って実行しないため、かならず `which certbot` でパスを確認
* DNS-01 チャレンジでは TXT レコードを利用するため、Propagation に時間がかかる場合がある
* Let’s Encrypt 証明書は 90 日間有効、期限内に必ず更新を行うこと
