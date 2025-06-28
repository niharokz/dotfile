#!/bin/bash

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

# default programs:
export EDITOR="nvim"
export TERMINAL="xterm"

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
export VSCODE_PORTABLE="$XDG_DATA_HOME/vscode"
#export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export LESSHISTFILE="-"
export ZDOTDIR="$HOME/.config/zsh"


# SSH from pgp
# if ! pgrep -u "$USER" ssh-agent > /dev/null; then
#    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
# fi

#if [[ ! "$SSH_AUTH_SOCK" ]]; then
#    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
#fi

# To check why not working
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java

# NPM
PATH="$HOME/.local/bin:$PATH"
export npm_config_prefix="$HOME/.local"

# RUST
# . "$HOME/.local/share/cargo/env"
export PATH="$HOME/.cargo/bin:$PATH"

gpgconf --launch gpg-agent
