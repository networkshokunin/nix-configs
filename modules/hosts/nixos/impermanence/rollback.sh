#!/bin/sh
set -e # エラーが発生したら中断

mkdir -p /mnt-root
# パーティションラベルでマウント（Diskoの設定に合わせる）
mount /dev/disk/by-partlabel/BTRFS /mnt-root

if [ -e /mnt-root/@root ]; then
    mkdir -p /mnt-root/old_roots
    timestamp=$(date "+%Y-%m-%d_%H:%M:%S")
    mv /mnt-root/@root "/mnt-root/old_roots/$timestamp"
fi

# 容量チェックと古いログの削除ロジック
usage=$(df /mnt-root | tail -n1 | awk '{print $5}' | sed 's/%//')
if [ "$usage" -gt 80 ]; then
    echo "Disk usage high ($usage%), cleaning up old roots..."
    ls -1tr /mnt-root/old_roots | head -n 1 | xargs -I{} btrfs subvolume delete "/mnt-root/old_roots/{}"
fi

btrfs subvolume create /mnt-root/@root
umount /mnt-root