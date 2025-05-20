## コンテナのプロセスを見る
docker exec -it コンテナ名 ps aux
## コンテナの名前を固定
devcontainer.jsonに下記を追加
    
    "runArgs": ["--name","<コンテナ名>"],

## ビルド

    docker build -f Dockerfile -t <イメージ名>  .

なお、Dockerfileに
```
WORKDIR /app
...
COPY . .
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
```
と書いて、データをコンテナにコピーすることと、起動後に実行するコマンドを書き忘れないこと

## 実行
ポート8000を8000につなぐ設定

    docker run --rm -p 8000:8000 <イメージ名>

さらにドッカーの中に入る場合

    docker run --rm -it -p 8000:8000 <イメージ名>

## ログ 
```
docker logs <コンテナ名>
```
