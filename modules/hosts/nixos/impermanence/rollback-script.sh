#!/usr/bin/env bash
old_roots_dir="/mnt/nixos/@old_roots"
root_dir="/mnt/nixos/root"
mkdir -p {/mnt,/mnt/nixos,$root_dir}
mount -t btrfs -L BTRFS $root_dir
if [[ -e $root_dir/@old_roots ]]; then
    timestamp=$(date "+%Y-%m-%d--%H-%M-%S")
    mkdir -p $old_roots_dir
    mount -t btrfs -o noatime,compress-force=zstd:1,subvol=@old_roots -L BTRFS $old_roots_dir
    if [[ -e $root_dir/@root ]]; then
        mv $root_dir/@root "$old_roots_dir/@root/$timestamp"
        btrfs subvolume create $root_dir/@root
    fi
    if [[ -e $root_dir/@persistent ]]; then
        mkdir -p $old_roots_dir/@persistent
        btrfs subvolume snapshot $root_dir/@persistent "$old_roots_dir/@persistent/$timestamp"
    fi
    # Clean up old backups older than the configured days
    find $old_roots_dir/ -maxdepth 2 -mtime +@removeTmpFilesOlderThan@ -type d | while IFS= read -r old; do
        if [[ "$old" == "$old_roots_dir/" || "$old" == "$old_roots_dir/@root/" || "$old" == "$old_roots_dir/@persistent/" ]]; then continue; fi
        btrfs subvolume delete "$old" 2>/dev/null || true  # Ignore errors if not a subvolume
    done
    umount $old_roots_dir
fi
umount $root_dir