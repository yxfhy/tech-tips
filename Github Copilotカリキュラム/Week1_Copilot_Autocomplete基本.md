# Week 1: Copilot Autocomplete 基本

## 1. 準備: VS Code と GitHub Copilot の設定
- VS Code の拡張機能から「GitHub Copilot」をインストール・有効化
- GitHub アカウントでサインイン

## 2. コメントドリブン生成
1. `exercise1.py` を作成  
2. ファイル冒頭に日本語コメントを記述  
   ```python
   # 与えられたリストを昇順にソートする関数を実装してください
   ```  
3. コメント直後にカーソルを置き、`Tab` で提案を受け入れ  
4. `Esc` で却下し、`Alt+]` / `Alt+[ `などで候補を切り替え

## 3. Copilot Chat の活用
- Copilot Chat パネルを開く:  
  - Windows/Linux: `Ctrl + Alt + I`  
  - macOS: `⌃⌘I`  
- 選択したコードに対して自然言語で指示  
  - 例: `Explain this function.`、`Fix this function to handle edge cases.`
- インラインチャット:  
  - `Ctrl + I`（Windows/Linux）／`⌘I`（macOS）

## 4. 主要ショートカット一覧
| 操作                         | Windows/Linux           | macOS               |
|-----------------------------|-------------------------|---------------------|
| 提案を受け入れる            | `Tab`                   | `Tab`               |
| 提案を却下する              | `Esc`                   | `Esc`               |
| 次の候補を表示              | `Alt + ]`               | `Option + ]`        |
| 前の候補を表示              | `Alt + [`               | `Option + [`        |
| 手動で提案をトリガー        | `Ctrl + Enter`          | `⌘ + Enter`         |
| インライン候補を強制表示    | `Alt + /`               | `Option + /`        |
| Copilot Chat ビューを開く   | `Ctrl + Alt + I`        | `⌃⌘I`               |

## 5. 課題
### 課題①：JSON → CSV 変換スクリプト
- ファイル名: `exercise_json_to_csv.py`
- コメントで指示を記述し、Copilot でコード生成  
- 実装例:
  ```python
  # 指定した JSON ファイルを読み込み
  # 各オブジェクトのキーをヘッダー行に、
  # 値を CSV 形式で出力する関数を実装してください
  ```
- テスト用 JSON を用意し、`test.csv` が正しく生成されるか確認

### 課題②：FizzBuzz 関数の実装
- ファイル名: `exercise_fizzbuzz.py`
- コメントで指示を記述し、Copilot でコード生成  
- 実装例:
  ```python
  # 1 から 100 までの数字について、
  # 3 の倍数なら "Fizz"、5 の倍数なら "Buzz"、
  # 3 と 5 両方の倍数なら "FizzBuzz" を出力する関数を実装してください
  ```
- `if __name__ == "__main__": fizzbuzz()` で動作確認

---
以上が Week 1 のまとめです。