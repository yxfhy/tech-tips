# インストールガイド

## 1. Dockerfile の作成
プロジェクトのルートディレクトリに `Dockerfile` を作成し、以下の内容を記述してください。

```Dockerfile
# JupyterLab 4.x 系を含む最小構成イメージ
FROM jupyter/minimal-notebook:lab-4.0.7

# Jupyter AI 本体・Magics拡張・OpenAIパッケージをバージョン固定でインストール
RUN pip install --no-cache-dir \
    jupyter_ai==2.31.4 \
    jupyter-ai-magics==2.31.4 \
    openai==1.77.0 \
    langchain-openai==0.3.16
```

## 2. Docker イメージのビルド
ターミナルで `Dockerfile` のあるディレクトリに移動し、以下のコマンドを実行してイメージをビルドします。

```bash
docker build -t jupyter-ai .
```

- `-t jupyter-ai` は作成するイメージに付ける名前です。  
- 成功すると `Successfully built …` が表示されます。

## 3. コンテナの起動とフォルダのマウント
ホスト側の `~/data` および `~/work` をコンテナ内の `/home/jovyan/data`、`/home/jovyan/work` にマウントして起動します。

```bash
docker run -it --rm \
  -p 8888:8888 \
  -e "OPENAI_API_KEY=<APIキー>" \
  -v $HOME/data:/home/jovyan/data \
  -v $HOME/work:/home/jovyan/work \
  jupyter-ai
```

- `-p 8888:8888`：ホストのポート8888をコンテナに割り当て  
- `-e "OPENAI_API_KEY=<APIキー>"`：環境変数に API キーを設定  
- `-v ホスト側パス:コンテナ側パス`：ホストフォルダをマウント  
- `--rm`：コンテナ終了時に自動削除

起動後、ブラウザで `http://localhost:8888` にアクセスして JupyterLab をご利用ください。
