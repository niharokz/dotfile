#!/usr/bin/env bash
# shellcheck disable=SC2088  # "~/..." in messages is display text, not a path
# naos cleanup: retires configs for tools no longer used and tidies the dotfiles repo.
# Shows the plan by default; nothing changes until --apply. Run as your user.
# Only folders tracked in git are deleted (they stay recoverable from history); untracked ones are just reported.
# Usage: bash ~/.config/naos/setup/cleanup.sh [--apply]
set -uo pipefail

[[ $EUID -ne 0 ]] || { echo "Run as your user, not root"; exit 1; }
APPLY=0; [[ ${1:-} == --apply ]] && APPLY=1

: "${XDG_CONFIG_HOME:=$HOME/.config}"
DOTGIT="$XDG_CONFIG_HOME/.dotfile"
dot() { git --git-dir="$DOTGIT" --work-tree="$HOME" "$@"; }
plan() { printf '  %-8s %s\n' "$1" "$2"; }
run()  { (( APPLY )) && "$@"; }
tracked() { [[ -n $(dot ls-files -- "$1" 2>/dev/null | head -n1) ]]; }

[[ -d $DOTGIT ]] || { echo "No dotfiles repo at $DOTGIT"; exit 1; }

echo "== retired configs (replaced by xmonad, kitty, nvim, niharfetch)"
for d in dwm vim alacritty termite neofetch; do
  p="$XDG_CONFIG_HOME/$d"; rel=".config/$d"
  [[ -e $p ]] || tracked "$rel" || continue
  if tracked "$rel"; then
    plan "remove" "$rel (in git history if ever needed)"
    run dot rm -r -q --cached -- "$rel"; run rm -rf -- "$p"
  else
    plan "keep" "$rel is not in git; delete it by hand if you are sure"
  fi
done

echo "== replaced files"
for rel in .config/xmobar/.xmobarrc .config/.alias .zprofile; do
  if tracked "$rel"; then plan "remove" "$rel"; run dot rm -q --cached -- "$rel"; fi
  [[ -e $HOME/$rel ]] && { plan "delete" "~/$rel"; run rm -f -- "$HOME/$rel"; }
done

echo "== README: edited in .config/readmedoc, root copy only in git"
if [[ -f $HOME/README.md && ! -f $XDG_CONFIG_HOME/readmedoc/README.md ]]; then
  plan "move" "~/README.md -> .config/readmedoc/README.md"
  run mv "$HOME/README.md" "$XDG_CONFIG_HOME/readmedoc/README.md"
fi
plan "hooks" "dot config core.hooksPath ~/.config/naos/setup/dot-hooks (copies the README to the root on commit)"
run dot config core.hooksPath "$XDG_CONFIG_HOME/naos/setup/dot-hooks"
run dot update-index -q --refresh
if [[ -f $HOME/README.md && -f $XDG_CONFIG_HOME/readmedoc/README.md ]] && ! dot diff --quiet -- README.md 2>/dev/null; then
  plan "reset" "~/README.md (the copy you edit is .config/readmedoc/README.md; the hook rebuilds the root one)"
  run dot checkout -- README.md
fi
plan "sparse" "keep README.md and .gitignore out of ~"
run dot sparse-checkout set --no-cone '/*' '!/README.md' '!/.gitignore'

echo "== X auth file"
if [[ -e $HOME/.Xauthority ]]; then
  if [[ -n ${XAUTHORITY:-} && $XAUTHORITY != "$HOME/.Xauthority" ]]; then
    plan "delete" "~/.Xauthority (X uses \$XDG_RUNTIME_DIR/Xauthority now)"; run rm -f "$HOME/.Xauthority"
  else
    plan "wait" "~/.Xauthority still in use: reboot once, then run this again"
  fi
fi

echo "== old installer backups"
while IFS= read -r -d '' f; do plan "delete" "${f/#$HOME/\~}"; run rm -f -- "$f"; done < <(
  find "$XDG_CONFIG_HOME" "$HOME/.local/bin" -maxdepth 3 -type f -name '*.bak-20[0-9][0-9]*' -print0 2>/dev/null)

echo "== worth a look (not changed)"
[[ -d $XDG_CONFIG_HOME/autostart ]] && plan "check" ".config/autostart: xmonad does not run these: $(find "$XDG_CONFIG_HOME/autostart" -mindepth 1 -maxdepth 1 -printf '%f ')"
for d in .vscode-shared .copilot; do [[ -e $HOME/$d ]] && plan "check" "~/$d"; done

echo
if (( APPLY )); then echo "Done. Review with: dot status"
else echo "Plan only. Run again with --apply to do it."; fi
