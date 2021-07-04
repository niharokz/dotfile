#!/bin/bash

#
#       ███╗   ██╗██╗██╗  ██╗ █████╗ ██████╗ ███████╗
#       ████╗  ██║██║██║  ██║██╔══██╗██╔══██╗██╔════╝
#       ██╔██╗ ██║██║███████║███████║██████╔╝███████╗
#       ██║╚██╗██║██║██╔══██║██╔══██║██╔══██╗╚════██║
#       ██║ ╚████║██║██║  ██║██║  ██║██║  ██║███████║
#       ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
#       DRAFTED BY [https://nihar.page] ON 11-05-2021.
#       SOURCE [.zprofile] LAST MODIFIED ON 27-06-2021.
#

# default programs:
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="brave"
export READER="zathura"

# XDG setup
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export XMONAD_CONFIG_HOME="$XDG_CONFIG_HOME/xmonad"
export XMONAD_DATA_HOME="$XDG_CONFIG_HOME/xmonad"
export XMONAD_DATA_HOME="$XDG_CONFIG_HOME/xmonad"
export XMONAD_CACHE_HOME="$XDG_CONFIG_HOME/xmonad"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export XSERVERRC="$XDG_CONFIG_HOME/X11/xserverrc"
export HISTFILE="$XDG_DATA_HOME/bash/history"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export HISTFILE="${XDG_DATA_HOME:-$HOME/.local/share}/history"
export LESSHISTFILE="-"

# Shortcut to directories
export DATA="/data/"
export BACKUP="/data/backup"
export WORK="/data/workspace/"
export ZDOTDIR="$HOME/.config/zsh"

# XDG for desktop
export XDG_DESKTOP_DIR="$DATA"
export XDG_DOWNLOAD_DIR="$HOME/download"
export XDG_DOCUMENTS_DIR="$HOME/download"
export XDG_MUSIC_DIR="$DATA/cloud/gdrive/music"
export XDG_PICTURES_DIR="$DATA/cloud/gdrive/photo"
export XDG_VIDEOS_DIR="$DATA/video"

# SSH from pgp
#export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

# To check why not working
# export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java

