#!/usr/bin/env bash

# 设置目标文件路径
target_file="$HOME/.cache/hyprland_client"

# 无限循环，不断检查
while true; do
    # 获取hyprctl clients命令的输出
    output=$(hyprctl clients)

    # 检查目标文件是否存在
    if [ ! -f "$target_file" ]; then
        # 文件不存在，则创建文件，并写入输出
        echo "$output" > "$target_file"
        break
    fi

    # 比较命令输出与文件内容
    if ! diff -q <(echo "$output") "$target_file" >/dev/null; then
        # 如果内容不同，更新文件
        echo "$output" > "$target_file"
        break
    fi
done

notify-send -u normal "clients saved"
