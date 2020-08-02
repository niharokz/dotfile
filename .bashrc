#
#		NAME		:	NIHAR SAMANTARAY
#		WEBSITE		:	HTTPS://NIHARS.COM
#		SOURCE		:	.bashrc
#		CREATED ON	:	06-06-20
#		MODIFIED ON	:	02-08-20
#

# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
. .environment_variables
. .alias
# PS1='[\u@\h \W]\$ '
# setup nice colors
#export GREP_OPTIONS='--color=auto'

if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then 
	exec startx; 
fi
alias grep='grep -n --color'
alias ls='ls --color'
export PS1="$(tput setaf 1)\w\n\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h\[$(tput setaf 5)\]\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$\[$(tput sgr0)\] "
neofetch



