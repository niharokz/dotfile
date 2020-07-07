#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

unset GREP_OPTIONS
feh --bg-scale /data/picture/system/wallpaper/greenpredator.jpg
/data/workspace/tools/xsetroot.sh 2> /tmp/bar.log &
exec dwm

