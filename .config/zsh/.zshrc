#!/bin/zsh

#
#       ███╗   ██╗██╗██╗  ██╗ █████╗ ██████╗ ███████╗
#       ████╗  ██║██║██║  ██║██╔══██╗██╔══██╗██╔════╝
#       ██╔██╗ ██║██║███████║███████║██████╔╝███████╗
#       ██║╚██╗██║██║██╔══██║██╔══██║██╔══██╗╚════██║
#       ██║ ╚████║██║██║  ██║██║  ██║██║  ██║███████║
#       ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
#       DRAFTED BY [https://nih.ar] ON 30-10-2020.
#       SOURCE [.zshrc] LAST MODIFIED ON 23-03-2026.
#

### ────────────────────────────
### 🧠 Shell Basics

autoload -U colors && colors
setopt autocd
stty stop undef

### ────────────────────────────
### 🎨 Prompt (with git)

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )

setopt prompt_subst

PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
RPROMPT=\$vcs_info_msg_0_

zstyle ':vcs_info:git:*' formats '%F{30}(%b)%r%f'
zstyle ':vcs_info:*' enable git

### ────────────────────────────
### 🗂 History

HISTSIZE=1000
SAVEHIST=1000
HISTFILE="$XDG_DATA_HOME/zsh/history"

### ────────────────────────────
### ⚡ Load Custom Layer (IMPORTANT ORDER)

[[ $- != *i* ]] && return

# Load functions FIRST (uses env like $WORK)
[ -f "$WORK/narch/shellfunctions.sh" ] && source "$WORK/narch/shellfunctions.sh"

# Then aliases
[ -f "$XDG_CONFIG_HOME/.alias" ] && source "$XDG_CONFIG_HOME/.alias"

### ────────────────────────────
### 🖥️ Auto Start X (TTY1)

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
  exec startx "$XDG_CONFIG_HOME/X11/xinitrc"
fi

### ────────────────────────────
### 📦 System Profiles

if [ -d /etc/profile.d ]; then
  for script in /etc/profile.d/*.sh; do
    [ -r "$script" ] && . "$script"
  done
fi

### ────────────────────────────
### 🔍 Completion

autoload -U compinit
zmodload zsh/complist
compinit
_comp_options+=(globdots)

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}'
eval "$(dircolors -b)"

### ────────────────────────────
### ⌨️ Keybindings (Vim Style)

bindkey -v
export KEYTIMEOUT=1

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey '^?' backward-delete-char

### ────────────────────────────
### 🖱️ Cursor Behavior

zle-keymap-select() {
  if [[ ${KEYMAP} == vicmd ]]; then
    echo -ne '\e[1 q'
  else
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

zle-line-init() {
  zle -K viins
  echo -ne "\e[5 q"
}
zle -N zle-line-init

preexec() { echo -ne '\e[5 q'; }

### ────────────────────────────
### 📁 Tools

lfcd() {
  tmp="$(mktemp)"
  lf -last-dir-path="$tmp" "$@"
  if [ -f "$tmp" ]; then
    dir="$(cat "$tmp")"
    rm -f "$tmp"
    [ -d "$dir" ] && cd "$dir"
  fi
}

bindkey -s '^o' 'lfcd\n'
bindkey -s '^a' 'bc -l\n'
bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'
bindkey '^[[P' delete-char

autoload edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line

### ────────────────────────────
### 🔌 Plugins

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh 2>/dev/null

### ────────────────────────────
### 🛠 Dev Environment

export GOPATH="$HOME/go"
export GOCACHE="$XDG_CACHE_HOME/go-build"
export PATH="$PATH:$GOPATH/bin"

export GPG_TTY="$(tty)"

### ────────────────────────────
### ⚡ Startup

macchina
