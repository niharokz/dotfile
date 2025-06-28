# ~/.bashrc

[[ $- != *i* ]] && return
. $XDG_CONFIG_HOME/.alias

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then 
	exec startx "$XDG_CONFIG_HOME/X11/xinitrc";
fi

alias grep='grep -n --color'
alias ls='ls --color'
export PS1="\n\[$(tput sgr0)\]\[$(tput bold)\]\[\$(tput setaf 3)\]\u\[$(tput sgr0)\][\[$(tput sgr0)\]\[\$(tput setaf 7)\]\w\[$(tput sgr0)\]]\\$\[$(tput sgr0)\] "
neofetch
# export PS1="$(tput setaf 7)\w\n\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h\[$(tput setaf 5)\]\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$\[$(tput sgr0)\] "
