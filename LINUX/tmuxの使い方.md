# ~/.tmux.conf (Emacs風設定)
```conf
# プレフィックスキーを Ctrl-a に変更
unbind-key C-b
set-option -g prefix C-a
bind-key C-a send-prefix

# ペイン移動を Emacs キーバインド (C-b: 左, C-f: 右, C-p: 上, C-n: 下)
bind-key C-b select-pane -L
bind-key C-f select-pane -R
bind-key C-p select-pane -U
bind-key C-n select-pane -D

# ウィンドウ分割 (水平/垂直)
bind-key % split-window -h
bind-key '"' split-window -v

# コピー・ペーストモード設定 (vi ではなく Emacs キーバインド)
setw -g mode-keys emacs

# ステータスバーをシンプルに
set -g status-bg colour235
set -g status-fg colour136
set -g status-left-length 20
set -g status-right-length 120
set -g status-left '#[fg=green]#S #[fg=yellow]'
set -g status-right '#[fg=cyan]%Y-%m-%d #[fg=white]%H:%M'

# キー一覧（help）を C-a ? に割り当て
bind-key ? list-keys
```  

# tmux 使用方法一覧 (Emacsキーバインド)

## プレフィックスキー
- **C-a**：全 tmux 操作の起点

## セッション操作
- **新規セッション作成**  
  ```bash
  tmux new -s セッション名
  ```
- **デタッチ（抜ける）**  
  ```
  C-a d
  ```
- **セッション一覧表示**  
  ```bash
  tmux ls
  ```
- **再アタッチ（戻る）**  
  ```bash
  tmux attach -t セッション名
  ```
- **全セッション終了**  
  ```bash
  tmux kill-server
  ```

## ウィンドウ操作
- **新規ウィンドウ作成**  
  ```
  C-a c
  ```
- **ウィンドウ移動**  
  ```
  C-a 数字キー（0〜9）
  C-a n / C-a p
  ```
- **ウィンドウ一覧表示**  
  ```
  C-a w
  ```
- **ウィンドウ名変更**  
  ```
  C-a ,
  ```

## ペイン操作
- **垂直分割（左右）**  
  ```
  C-a %
  ```
- **水平分割（上下）**  
  ```
  C-a "
  ```
- **ペイン間移動（Emacs風）**  
  ```
  C-a C-b  ← 左  
  C-a C-f  → 右  
  C-a C-p  ↑ 上  
  C-a C-n  ↓ 下  
  ```
- **ペイン閉じる**  
  ```
  C-a x （y キーで確定）
  ```
- **ペインサイズ調整**  
  ```
  C-a : resize-pane -L/-R/-U/-D [サイズ]
  ```

## コピー＆ペースト（Emacsキーバインド）
- **コピー・モードに入る**  
  ```
  C-a [
  ```
  （矢印で移動→スペースで選択開始→Enterでコピー）
- **ペースト**  
  ```
  C-a ]
  ```

## 設定再読み込み
- **~/.tmux.conf を再読み込み**  
  ```
  C-a : source-file ~/.tmux.conf
  ```

## トラブルシュート：C-a c が動かない場合
1. **プレフィックス設定を確認**  
   ```
   C-a : show-options -g prefix
   ```
2. **キー一覧を表示**  
   ```
   C-a ?
   ```
3. **設定再読み込み**  
   ```
   C-a : source-file ~/.tmux.conf
   ```
4. **tmux 再起動**  
   ```bash
   tmux kill-server
   tmux new -s お好みの名前
   ```
5. **手動でウィンドウ作成**  
   ```bash
   tmux new-window
   ```

