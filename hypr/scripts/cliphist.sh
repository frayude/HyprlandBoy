#!/usr/bin/env bash

# File: ~/.config/hypr/scripts/cliphist.sh

# Rofi configuration file
ROFI_CONFIG="$HOME/.config/rofi/config-cliphist.rasi"

case $1 in
    d)
        # Menampilkan daftar dan menghapus item yang dipilih
        cliphist list | rofi -dmenu -replace -config $ROFI_CONFIG -p "Delete Clip: " | cliphist delete
    ;;
    w)    
        # Menghapus semua riwayat clipboard
        cliphist wipe
    ;;
    *)
        # Default: Menampilkan, memilih, menyalin, dan menutup
        cliphist list | rofi -dmenu -replace -config $ROFI_CONFIG -p "Clip History: " | cliphist decode | wl-copy
    ;;
esac