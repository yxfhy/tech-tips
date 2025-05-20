# 使用ガイド

## 1. Magics拡張の読み込み
ipynbファイルを開いたら、最初のセルで以下を実行してください。

```python
%load_ext jupyter_ai_magics
```

## 2. 利用可能な言語モデルの表示
どのモデルが使えるかを確認するには、次のコマンドを実行します。

```python
%ai list
```

## 3. エイリアス設定
好みの名前（例：mychat）にモデルを割り当てるには、以下のように更新します。

```python
%ai register mychat openai-chat:gpt-4o-2024-11-20
```

## 4. エイリアスを使ったプロンプト送信
設定したエイリアス名を使うと、指定モデルで応答が返ってきます。セルの先頭に `%%ai mychat` と書き、その下にプロンプトを入力します。

```python
%%ai mychat
How do you do !
```

このセルを実行すると、`openai-chat:gpt-4o-2024-11-20` モデルが応答いたします。

## 5. GUIによる設定とチャットペインの表示
JupyterLab の設定画面からもモデル選択やAPIキー入力が可能で、設定後は左側ペインで直接チャットできます。

1. **Settings** → **Jupyter AI Settings** を開く  
2. **Language model** から使用したいモデルを選択  
3. **Embedding model** を選択  
4. 必要に応じて **Inline completions model** を設定  
5. **OPENAI_API_KEY** 欄に API キーを入力  
6. **Save Changes** をクリック  
7. 左側サイドバーの 🧠 **AI Chat** アイコンをクリック  

## 6. 既存セルを参照した質問
特定のセルの入力内容をモデルに渡して質問するには、`{In[セル番号]}` プレースホルダを使います。

```python
%%ai mychat
{In[35]}
What does this code do?
```

## 7. 出力フォーマットオプションの指定 (-f / --format)
`-f` または `--format` オプションで応答の形式を指定できます。  
利用可能なフォーマットは以下の通りです。

```
code | html | image | json | markdown | math | md | text
```

**例：コード形式で生成**

```python
%%ai mychat -f code
data/titanic/train.csv のデータの列名を表示
```

**出力例：**

```python
import pandas as pd

# データセットの読み込み
data = pd.read_csv("data/titanic/train.csv")

# 列名を表示
print(data.columns.tolist())
```

## 8. ヘルプの表示
使用可能なマジックコマンドやオプションの詳細を確認するには、以下を実行してください。

```python
%ai help
```

これで各コマンドの使い方やオプション一覧が表示されます。
