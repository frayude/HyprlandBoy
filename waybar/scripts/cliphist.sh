#!/usr/bin/env bash

# Skrip ini mengelola riwayat clipboard (cliphist) menggunakan wofi.
# Argument:
#   d: Menampilkan riwayat dan menghapus item yang dipilih.
#   w: Membersihkan SELURUH riwayat.
#   (default): Menampilkan riwayat dan menempel (paste) item yang dipilih.

WOFI_DMENU="wofi -dmenu -S dmenu" # Gunakan mode dmenu pada Wofi

case $1 in
    d)
        # Menampilkan, membiarkan user memilih, lalu menghapus item yang dipilih
        cliphist list | $WOFI_DMENU | cliphist delete
        ;;

    w)  
        # Menampilkan konfirmasi "Clear/Cancel" dan menghapus seluruh riwayat jika "Clear" dipilih
        if [ "$($WOFI_DMENU -p "Hapus semua riwayat?")" == "Clear" ]; then
            cliphist wipe
        fi
        ;;

    *)
        # Menampilkan riwayat, membiarkan user memilih, mendekode, lalu menyalin (wl-copy)
        cliphist list | $WOFI_DMENU | cliphist decode | wl-copy
        ;;
esac
