#!/bin/zsh

# =========================================================
# Dotfiles Setup Script
# Creates symbolic links for configuration files.
# =========================================================

# ドットファイルリポジトリのルートディレクトリを取得
DOTFILES_DIR="$(dirname "$(realpath "$0")")"

# 設定ファイルとターゲットパスの定義
# 形式: "ソースパス:ターゲットパス:説明"
declare -a configs=(
    "zsh/zshrc:$HOME/.zshrc:Zsh"
    # ~/.zshenv は存在しなかったため、ここではシンボリックリンクは張らない
    # ~/.zsh ディレクトリは存在しなかったため、ここではシンボリックリンクは張らない
    "git/gitconfig:$HOME/.gitconfig:Git"
    ".vscode/settings.json:$HOME/Library/Application Support/Code/User/settings.json:VSCodeSettings"
    "starship/starship.toml:$HOME/.config/starship.toml:Starship"
    "raycast/Raycast 2025-07-29 23.35.46.rayconfig:$HOME/Library/Application Support/com.raycast.raycast/Raycast.rayconfig:Raycast" # Raycastも管理するならこの行を追加
    # ghostty/config:$HOME/.config/ghostty/config:Ghostty # Ghosttyがあれば追加
)

echo "Dotfiles setup started."
echo "Dotfiles directory: $DOTFILES_DIR"

# シンボリックリンクの作成ループ
for config in "${configs[@]}"; do
    # config文字列を ':' で分割して変数に代入
    IFS=':' read -r source_relative_path target_path description <<< "$config"

    source_full_path="$DOTFILES_DIR/$source_relative_path"

    echo "" # 空行で区切り

    # ソースファイル/ディレクトリが存在するか確認
    if [ ! -e "$source_full_path" ]; then
        echo "🚨 Warning: Source file/directory does not exist for $description: $source_full_path"
        continue # 次の項目へスキップ
    fi

    echo "🔗 Processing $description configuration..."
    echo "   Source: $source_full_path"
    echo "   Target: $target_path"

    # ターゲットパスの親ディレクトリが存在しない場合は作成
    target_dir="$(dirname "$target_path")"
    if [ ! -d "$target_dir" ]; then
        echo "   Creating target directory: $target_dir"
        mkdir -p "$target_dir"
        if [ $? -ne 0 ]; then
            echo "❌ Error: Failed to create directory $target_dir. Skipping $description."
            continue
        fi
    fi

    # 既存のターゲットファイル/リンク/ディレクトリを削除
    if [ -L "$target_path" ]; then
        echo "   Removing existing symbolic link: $target_path"
        rm "$target_path"
    elif [ -f "$target_path" ]; then
        echo "   Removing existing file: $target_path (backing up if necessary)"
        # バックアップが必要な場合はここでmvでバックアップ
        rm "$target_path"
    elif [ -d "$target_path" ]; then
        echo "   Removing existing directory: $target_path (careful!)"
        # ディレクトリを削除する場合は非常に注意が必要。
        # 今回のケースでは.zshのようなディレクトリを丸ごとリンクする場合に必要だが、
        # 通常のファイルリンクでは不要。もし過去に手動でディレクトリを作っていたら問題になる。
        # 一旦 rm -rf は避け、ユーザーに手動削除を促すか、より安全な処理に留める。
        # 今回のスクリプトでは、ファイル/リンクの削除に限定する。
        # もしディレクトリを上書きリンクする場合は、ln -sF を使うか、rm -r で削除してからリンクする。
        # 現在の configs 定義ではディレクトリのシンボリックリンクは .zsh だけだが、それは存在しないため、
        # ここではこのブロックは原則として実行されないはず。
        echo "   Please manually move or remove $target_path if it's a directory and you wish to link over it."
        continue # スキップして手動対応を促す
    fi


    # シンボリックリンクを作成
    ln -s "$source_full_path" "$target_path"
    if [ $? -eq 0 ]; then
        echo "   ✅ Successfully linked $description."
    else
        echo "   ❌ Error: Failed to link $description. Check permissions or path."
    fi
done

echo "" # 空行で区切り
echo "Dotfiles setup completed."