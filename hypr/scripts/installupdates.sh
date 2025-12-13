#!/usr/bin/env bash
#    ____         __       ____               __     __
#   /  _/__  ___ / /____ _/ / / __ _____  ___/ /__ _/ /____ ___
#  _/ // _ \(_-</ __/ _ `/ / / / // / _ \/ _  / _ `/ __/ -_|_-<
# /___/_//_/___/\__/\_,_/_/_/  \_,_/ .__/\_,_/\_,_/\__/\__/___/
#                                 /_/
#

set -e
# Check if command exists
_checkCommandExists() {
    cmd="$1"
    # if ! command -v "$cmd" >/dev/null; then
    #     echo 1
    #     return
    # fi
    # echo 0
    # return
    command -v "$cmd" >/dev/null 2>&1
    return $?
}

_isInstalled() {
    package="$1"
    case $install_platform in
        arch)
            check="$($aur_helper -Qs --color always "${package}" | grep "local" | grep "${package} ")"
            ;;
        fedora)
            check="$(dnf repoquery --quiet --installed ""${package}*"")"
            ;;
        *) ;;
    esac

    if [ -n "${check}" ]; then
        echo 0 #'0' means 'true' in Bash
        return #true
    fi
    echo 1 #'1' means 'false' in Bash
    return #false
}

# ------------------------------------------------------
# Confirm Start
# ------------------------------------------------------

sleep 1
clear
figlet "Updates"
echo

if gum confirm --selected.background="1" "DO YOU WANT TO START THE UPDATE NOW?"; then
    echo
    echo ":: Update started..."
elif [ $? -eq 130 ]; then
    exit 130
else
    echo
    echo ":: Update canceled."
    exit
fi

# ----------------------------------------------------- 
# Install update
# ----------------------------------------------------- 

if _checkCommandExists "pacman"; then
    echo ":: Arch Linux system detected. Starting update..."

    # Prioritize Paru
    if _checkCommandExists "paru"; then
        echo ":: Using 'paru' to update system and AUR."
        paru -Syu --noconfirm
    # Fallback to Yay
    elif _checkCommandExists "yay"; then
        echo ":: Using 'yay' to update system and AUR."
        yay -Syu --noconfirm
    # Fallback to Pacman (Core repositories only)
    else
        echo ":: AUR helper not found. Updating official repositories only with 'pacman'."
        sudo pacman -Syu --noconfirm
    fi
    echo
fi

# # Flatpak
# echo ":: Searching for Flatpak updates..."
# flatpak update -y
# echo

# Reload Waybar jika sedang berjalan
if pgrep -x "waybar" >/dev/null; then
    pkill -RTMIN+1 waybar
    echo ":: Waybar reloaded"
fi

# Dunst notification
if _checkCommandExists "notify-send"; then
    notify-send -t 0 "Update Done" "System is up to date"
fi


