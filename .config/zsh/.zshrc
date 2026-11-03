#!/bin/zsh

#
#       ███╗   ██╗██╗██╗  ██╗ █████╗ ██████╗ ███████╗
#       ████╗  ██║██║██║  ██║██╔══██╗██╔══██╗██╔════╝
#       ██╔██╗ ██║██║███████║███████║██████╔╝███████╗
#       ██║╚██╗██║██║██╔══██║██╔══██║██╔══██╗╚════██║
#       ██║ ╚████║██║██║  ██║██║  ██║██║  ██║███████║
#       ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
#       DRAFTED BY [https://nih.ar] ON 30-10-2020
#       SOURCE [.zshrc] LAST MODIFIED ON 03-11-2026
#
#       Interactive shell only. Environment lives in .zprofile, aliases in aliases.zsh.
#

[[ -o interactive ]] || return

### ────────────────────────────
### 🧠 Options

setopt autocd                    # type a folder name to cd into it
setopt interactive_comments      # allow # comments at the prompt
setopt no_beep
stty stop undef 2>/dev/null      # free Ctrl+S

### ────────────────────────────
### 🗂 History (kept in ~/.local/state)

HISTFILE="$XDG_STATE_HOME/zsh/history"
[[ -d ${HISTFILE:h} ]] || mkdir -p "${HISTFILE:h}"
HISTSIZE=50000
SAVEHIST=50000
setopt share_history             # all open shells see each other's commands
setopt hist_ignore_all_dups      # keep only the newest copy of a command
setopt hist_ignore_space         # " cmd" is not saved (handy for secrets)
setopt hist_reduce_blanks
setopt extended_history          # store timestamps

### ────────────────────────────
### 🎨 Prompt (nss colours, git branch on the right)

autoload -Uz vcs_info
precmd_functions+=(vcs_info)
setopt prompt_subst
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%F{#3A807A}(%b)%f'
zstyle ':vcs_info:git:*' actionformats '%F{#E0A63A}(%b|%a)%f'

# [nihar@naos-l ~/path]$   red $ after a failed command
PROMPT='%B%F{#1F2C33}[%F{#66BDB3}%n%F{#5C6B6A}@%F{#A9B8FF}%m %F{#E6ECEC}%~%F{#1F2C33}]%(?.%F{#8B979A}.%F{#FF6B6B})$%f%b '
RPROMPT='${vcs_info_msg_0_}'

### ────────────────────────────
### 🔍 Completion (cache kept in ~/.cache)

autoload -Uz compinit
zmodload zsh/complist
[[ -d $XDG_CACHE_HOME/zsh ]] || mkdir -p "$XDG_CACHE_HOME/zsh"
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
_comp_options+=(globdots)                                        # complete hidden files too
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}'          # case-insensitive
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
eval "$(dircolors -b)"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

### ────────────────────────────
### ⌨️ Vim keys

bindkey -v
export KEYTIMEOUT=1
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey '^?' backward-delete-char
bindkey '^[[P' delete-char

# block cursor in normal mode, beam in insert mode
zle-keymap-select() { [[ $KEYMAP == vicmd ]] && echo -ne '\e[1 q' || echo -ne '\e[5 q'; }
zle -N zle-keymap-select
zle-line-init() { zle -K viins; echo -ne '\e[5 q'; }
zle -N zle-line-init
preexec_functions+=(_naos_beam_cursor)
_naos_beam_cursor() { echo -ne '\e[5 q'; }

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^e' edit-command-line                                   # edit the current line in nvim

### ────────────────────────────
### 📁 Tools

# lf that cds into the last folder you were in
lfcd() {
  local tmp dir
  tmp="$(mktemp)"
  lf -last-dir-path="$tmp" "$@"
  if [[ -f $tmp ]]; then
    dir="$(<"$tmp")"; rm -f "$tmp"
    [[ -d $dir ]] && cd "$dir"
  fi
}
bindkey -s '^o' 'lfcd\n'
bindkey -s '^a' 'bc -lq\n'
bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'

### ────────────────────────────
### 🧩 Functions and aliases

[[ -f $WORK/narch/shellfunctions.sh ]] && source "$WORK/narch/shellfunctions.sh"
[[ -f $ZDOTDIR/aliases.zsh ]] && source "$ZDOTDIR/aliases.zsh"

export GPG_TTY="$TTY"                                            # pinentry needs the current tty

### ────────────────────────────
### 🔌 Plugins (Debian and Arch install them in different places)

_naos_plugin() {  # _naos_plugin <name> <file>: source the first copy found
  local dir
  for dir in /usr/share/zsh/plugins/$1 /usr/share/$1 $XDG_DATA_HOME/zsh/plugins/$1; do
    [[ -r $dir/$2 ]] && { source "$dir/$2"; return 0; }
  done
  return 1
}
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#5C6B6A'
_naos_plugin zsh-autosuggestions zsh-autosuggestions.zsh
_naos_plugin zsh-you-should-use you-should-use.plugin.zsh
_naos_plugin zsh-history-substring-search zsh-history-substring-search.zsh \
  && { bindkey -M vicmd 'k' history-substring-search-up; bindkey -M vicmd 'j' history-substring-search-down; }
_naos_plugin zsh-syntax-highlighting zsh-syntax-highlighting.zsh  # must be last
unfunction _naos_plugin

### ────────────────────────────
### ⚡ Greeting

[[ -x $WORK/narch/niharfetch.sh && -z $NVIM ]] && "$WORK/narch/niharfetch.sh" --quick
