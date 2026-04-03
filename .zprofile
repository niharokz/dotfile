#!/bin/zsh

#
#       ███╗   ██╗██╗██╗  ██╗ █████╗ ██████╗ ███████╗
#       ████╗  ██║██║██║  ██║██╔══██╗██╔══██╗██╔════╝
#       ██╔██╗ ██║██║███████║███████║██████╔╝███████╗
#       ██║╚██╗██║██║██╔══██║██╔══██║██╔══██╗╚════██║
#       ██║ ╚████║██║██║  ██║██║  ██║██║  ██║███████║
#       ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
#       DRAFTED BY [https://nih.ar] ON 11-05-2021.
#       SOURCE [.zprofile] LAST MODIFIED ON 04-04-2026
#

### ────────────────────────────
### 🧠 Core Programs

export EDITOR="nvim"
export TERMINAL="xterm"

### ────────────────────────────
### 📁 Base Paths (IMPORTANT)

export DATAR="/home/datar"
export DATA="$DATAR/data"

### Custom Shortcuts #######################################################
export WORK="$DATA/workspace"
export NOTES="$DATA/notes"
export BACKUP="$DATA/backups"

### History (Zsh) ##########################################################
export HISTFILE="$XDG_DATA_HOME/zsh/history"

### ────────────────────────────
### 📦 XDG Setup

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

export XMONAD_CONFIG_HOME="$XDG_CONFIG_HOME/xmonad"
export XMONAD_DATA_HOME="$XDG_CONFIG_HOME/xmonad"
export XMONAD_CACHE_HOME="$XDG_CONFIG_HOME/xmonad"

export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export XSERVERRC="$XDG_CONFIG_HOME/X11/xserverrc"

export LESSHISTFILE="-"
export ZDOTDIR="$HOME/.config/zsh"

### ────────────────────────────
### 📁 User Directories (XDG)

export XDG_DESKTOP_DIR="$DATA"
export XDG_DOWNLOAD_DIR="$DATA/download"
export XDG_DOCUMENTS_DIR="$DATA/documents"
export XDG_MUSIC_DIR="$DATA/musics"
export XDG_PICTURES_DIR="$DATA/photos"
export XDG_VIDEOS_DIR="$DATA/videos"

### ────────────────────────────
### ☕ Java Fix

export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"

### ────────────────────────────
### 📦 NPM

export npm_config_prefix="$HOME/.local"

### ────────────────────────────
### 🔐 GPG

gpgconf --launch gpg-agent
export GPG_TTY="$(tty)"

### ────────────────────────────
### 🐹 GO

export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export GOCACHE="$XDG_CACHE_HOME/go/build"
export GOENV="$XDG_CONFIG_HOME/go/env"
export GOBIN="$HOME/.local/bin"
export PATH="$GOBIN:$GOPATH/bin:$PATH"

### ────────────────────────────
### 📦 PATH (clean order)

export PATH="$HOME/.local/bin:$HOME/.cargo/bin:$PATH"
