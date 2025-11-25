#!/usr/bin/env zsh

#
#       ███╗   ██╗██╗██╗  ██╗ █████╗ ██████╗ ███████╗
#       ████╗  ██║██║██║  ██║██╔══██╗██╔══██╗██╔════╝
#       ██╔██╗ ██║██║███████║███████║██████╔╝███████╗
#       ██║╚██╗██║██║██╔══██║██╔══██║██╔══██╗╚════██║
#       ██║ ╚████║██║██║  ██║██║  ██║██║  ██║███████║
#       ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
#       DRAFTED BY [https://nih.ar] ON 11-05-2021.
#       SOURCE [.zprofile] LAST MODIFIED ON 31-05-2025.
#

### Default Programs #######################################################
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="microsoft-edge-stable"
export READER="zathura"
export DATA="/data"

### XDG Base Directory Setup ###############################################
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"

export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export LESSHISTFILE="-"

### XMonad Paths ############################################################
export XMONAD_CONFIG_HOME="$XDG_CONFIG_HOME/xmonad"
export XMONAD_DATA_HOME="$XDG_DATA_HOME/xmonad"
export XMONAD_CACHE_HOME="$XDG_CACHE_HOME/xmonad"

### History (Zsh) ##########################################################
export HISTFILE="$XDG_DATA_HOME/zsh/history"

### PATH ###################################################################
export PATH="$HOME/.local/bin:$PATH"

### Custom Shortcuts ########################################################
export CLOUD="$DATA/nextcloud"
export BACKUP="$HOME/backup"
export WORK="$DATA/workspace/"
export ZDOTDIR="$HOME/.config/zsh"

### XDG Desktop Directories ################################################
# (Applications will use ~/.config/user-dirs.dirs)
export XDG_DESKTOP_DIR="$HOME/desktop"
export XDG_DOWNLOAD_DIR="$HOME/download"
export XDG_DOCUMENTS_DIR="$HOME/documents"
export XDG_MUSIC_DIR="$DATA/cloud/gdrive/music"
export XDG_PICTURES_DIR="$DATA/cloud/gdrive/photo"
export XDG_VIDEOS_DIR="$DATA/video"

### SSH Agent ###############################################################
if ! pgrep -u "$USER" ssh-agent >/dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
[[ -z "$SSH_AUTH_SOCK" ]] && source "$XDG_RUNTIME_DIR/ssh-agent.env" 2>/dev/null

### Java XDG Fix ############################################################
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"

### NPM #####################################################################
export npm_config_prefix="$HOME/.local"

### AI ######################################################################
export OLLAMA_MODEL_DIR="$DATA/workspace/ai/models"
export OLLAMA_MODELS="$DATA/workspace/ai/models"
