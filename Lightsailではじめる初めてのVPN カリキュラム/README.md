# Lightsailではじめる初めてのVPN

## 0. はじめに
このカリキュラムでは **「AWS Lightsail で Ubuntu インスタンスを立ち上げ、WireGuard VPN を構築し、トレント通信と DuckDNS 連携の簡易 Web サーバを運用する」** ところまでを順序立てて学びます。  
学習時間の目安は 2 〜 3 時間です。

### 前提
- AWS アカウント（クレジットカード登録済み）
- PC に SSH クライアント（Windows 10 以降なら OpenSSH で可）
- 基本的な Linux コマンド操作への理解

---

## 1. Lightsail インスタンスを作成する
1. **Lightsail コンソール** (https://lightsail.aws.amazon.com/) にログイン。  
2. **Create instance** をクリックし、以下を設定  
   - **Region:** *Tokyo (ap‑northeast‑1)*  
   - **Platform:** *Linux/Unix*  
   - **Blueprint:** *Ubuntu 22.04 LTS*  
   - **SSH key pair:** 事前に作成した公開鍵を **Import** して選択  
   - **Plan:** *USD 5 (512 MB RAM / 20 GB SSD / 1 TB transfer)*  
3. 右下 **Create instance** で起動。数十秒でステータスが *Running* になります。

### 1‑A. 静的 IP を割り当てる (任意)
1. Lightsail > Networking > **Create static IP**。  
2. 作成したインスタンスを選択し **Attach**。  
   ※ IP を切り離さない限り無料ですが、未接続が 1 時間超えると 0.005 USD/時 課金される点に注意。

---

## 2. SSH キーを使って接続する
```bash
# 秘密鍵が ~/.ssh/lightsail_key の例
ssh -i ~/.ssh/lightsail_key ubuntu@<Lightsail_Public_IP>
```
初回ログイン後 `sudo apt update && sudo apt upgrade -y` を実行し、システムを最新化します。

---

## 3. WireGuard を構築する

### 3‑1. 鍵ペアの生成（サーバ側）
```bash
sudo apt install -y wireguard
umask 077
wg genkey | sudo tee /etc/wireguard/server.key | wg pubkey | sudo tee /etc/wireguard/server.pub
```

### 3‑2. サーバ設定 `/etc/wireguard/wg0.conf`
```
[Interface]
Address = 10.66.66.1/24
ListenPort = 51820
PrivateKey = <server.keyの内容>
PostUp   = iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
```

```bash
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
sudo systemctl enable --now wg-quick@wg0
```

### 3‑3. クライアント (PC) の設定
```bash
# ローカルで鍵生成
wg genkey | tee ~/client.key | wg pubkey | tee ~/client.pub
```
ファイル `wg0.conf`
```
[Interface]
Address = 10.66.66.2/24
PrivateKey = <client.key>
DNS = 1.1.1.1

[Peer]
PublicKey = <server.pub>
Endpoint = <Lightsail_Static_IP>:51820
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
```
接続: `sudo wg-quick up wg0`

### 3‑4. ファイアウォール
Lightsail Networking で **UDP 51820** を自宅 IP のみ許可。

---

## 4. トレント通信を VPN 経由にする
1. **qBittorrent** → 設定 → 接続  
2. 「ネットワークインターフェースをバインド」で `wg0` を選択  
3. 送信 (アップロード) 制限を設定（例: 500 KB/s）  
4. 外部からは Lightsail IP しか見えず、自宅 IP は秘匿されます。

---

## 5. DuckDNS で動的 DNS を取得する
1. https://www.duckdns.org に GitHub / Google などでログイン  
2. 好きなサブドメイン（例 `myvpn.duckdns.org`）を登録  
3. トークンをメモ  
4. Lightsail に更新スクリプトを設置  
```bash
sudo apt install -y cron
echo "*/5 * * * * root curl -k https://www.duckdns.org/update?domains=myvpn&token=<TOKEN>&ip=" | sudo tee /etc/cron.d/duckdns
```

---

## 6. 簡易 Web サーバ (Nginx) を公開
```bash
sudo apt install -y nginx
sudo ufw allow 80/tcp
echo '<h1>Hello from Lightsail VPN box</h1>' | sudo tee /var/www/html/index.html
```
ブラウザで `http://myvpn.duckdns.org` にアクセスし、表示を確認。

---

## 7. 運用とセキュリティベストプラクティス
| 項目 | 推奨策 |
|------|--------|
| アップデート | `sudo apt upgrade -y` を週1で実行 |
| WireGuard 再接続 | `PersistentKeepalive` を設定し、NAT越えを安定化 |
| 転送量の監視 | Lightsail の **Metrics → NetworkOut** アラームを 80 % で通知 |
| バックアップ | 月1で Lightsail スナップショットを取得 |

---

## 付録
### A. インスタンスのプラン変更
Lightsail → インスタンス → **Scale** からダウングレード／アップグレード可能。上位プランへ変更後、翌月に戻すことで超過転送料より安く済む場合があります。

### B. 参考リンク
- WireGuard 公式: https://www.wireguard.com/
- DuckDNS 公式: https://www.duckdns.org/
- AWS Lightsail 料金: https://aws.amazon.com/jp/lightsail/pricing/

---

お疲れさまでした！ 以上で「Lightsailではじめる初めてのVPN」カリキュラムは完了です。
