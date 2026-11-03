#!/bin/zsh

#
#       ███╗   ██╗██╗██╗  ██╗ █████╗ ██████╗ ███████╗
#       ████╗  ██║██║██║  ██║██╔══██╗██╔══██╗██╔════╝
#       ██╔██╗ ██║██║███████║███████║██████╔╝███████╗
#       ██║╚██╗██║██║██╔══██║██╔══██║██╔══██╗╚════██║
#       ██║ ╚████║██║██║  ██║██║  ██║██║  ██║███████║
#       ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
#       DRAFTED BY [https://nih.ar] ON 30-09-2020
#       SOURCE [aliases.zsh] LAST MODIFIED ON 03-11-2026
#
#       Sourced by .zshrc. Secrets stay in $XDG_CONFIG_HOME/.secrets (not in git).
#

[[ -f $XDG_CONFIG_HOME/.secrets ]] && source "$XDG_CONFIG_HOME/.secrets"

### ────────────────────────────
### 🔧 Command shortcuts

alias c='clear'
alias g='git'
alias v='nvim'
alias vi='nvim'
alias f='fzf'
alias s='sudo'
alias home='cd ~'
alias ports='sudo lsof -i -P -n | grep LISTEN'

# eza replaced exa (exa is not in Debian 13); fall back to ls
if (( $+commands[eza] )); then alias l='eza -las date --group-directories-first'
else alias l='ls -lAht --color=auto'; fi

(( $+commands[batcat] )) && ! (( $+commands[bat] )) && alias bat='batcat'
alias z='nvim $(fzf -m --preview="batcat --color=always {}")'

alias yt='yt-dlp'
alias yta='yt -x -f bestaudio/best --add-metadata -o "%(title)s.%(ext)s"'

alias code='code --extensions-dir "$XDG_DATA_HOME/vscode"'

### ────────────────────────────
### 🧬 Dotfiles (bare repo)

alias dot='/usr/bin/git --git-dir=$XDG_CONFIG_HOME/.dotfile --work-tree=$HOME'
compdef dot=git 2>/dev/null                                      # git completion for dot

### ────────────────────────────
### 🐳 Docker

alias d='docker'
alias dc='docker compose'
alias dprune='docker system prune -f'
dr()       { dc down && dc up -d; }
dbr()      { dc down && dc build --no-cache && dc up -d; }
dlogs()    { dc logs -f; }
dps()      { dc ps; }
drestart() { dc restart; }

### ────────────────────────────
### 📁 Navigation

alias b='cd $BACKUP'
alias data='cd $DATA'
alias ddata='cd $DATA'
alias w='cd $WORK'
alias work='cd $WORK'
alias fybo='cd $WORK/fybo'
alias narch='cd $WORK/narch'
alias nhr='cd $WORK/nih.ar'
alias video='cd $DATA/video'
alias n='cd $DATA/notes'
alias note='cd $DATA/notes'

### ────────────────────────────
### 🧠 Dev

alias pyenv='source $WORK/pyenv/bin/activate'
alias h='python3 $WORK/narch/headerize.py'
alias sn='ssh nimory'
alias nf='$WORK/narch/niharfetch.sh'

### ────────────────────────────
### ⚡ narch helpers (from shellfunctions.sh)

alias rmv='safe_move'
alias ex='extract_archive'
alias t='create_backup'
alias xt='extract_tar'           # was "tr", which hid the real tr command

### ────────────────────────────
### 📦 Packages (distro read in a subshell so os-release names don't leak into the shell)

case "$(. /etc/os-release 2>/dev/null; echo "$ID")" in
  arch)
    alias yay='paru'
    alias nay='paru -Rns'
    ;;
  debian)
    alias apt='sudo apt'
    alias nay='sudo apt remove --purge'
    alias update='sudo apt update && sudo apt upgrade && sudo apt autoremove'
    ;;
esac
