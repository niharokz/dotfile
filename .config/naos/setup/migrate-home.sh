#!/usr/bin/env bash
# naos home cleanup: moves what can live under XDG folders and removes leftovers.
# Lives in the dotfiles repo at ~/.config/naos/setup/ so a reinstall needs nothing else.
# Shows the plan by default; nothing changes until you pass --apply. Run as your user.
# Usage: bash migrate-home.sh            (plan)
#        bash migrate-home.sh --apply    (do it)
set -uo pipefail

[[ $EUID -ne 0 ]] || { echo "Run as your user, not root"; exit 1; }
APPLY=0; [[ ${1:-} == --apply ]] && APPLY=1

: "${XDG_CONFIG_HOME:=$HOME/.config}" "${XDG_DATA_HOME:=$HOME/.local/share}" "${XDG_STATE_HOME:=$HOME/.local/state}"
DATA=${DATA:-/data}
PARKED="$DATA/backup/home-cleanup"                                 # loose files from ~ end up here
DOTGIT="$XDG_CONFIG_HOME/.dotfile"
dot() { git --git-dir="$DOTGIT" --work-tree="$HOME" "$@"; }

plan()  { printf '  %-8s %s\n' "$1" "$2"; }
run()   { (( APPLY )) && "$@"; }                                   # only runs with --apply

move() {  # move SRC DEST: only if SRC exists and DEST does not
  local src=$1 dest=$2
  [[ -e $src || -L $src ]] || return 0
  if [[ -e $dest ]]; then plan "skip" "$src (already have $dest; merge by hand)"; return 0; fi
  plan "move" "$src -> $dest"
  run mkdir -p "$(dirname "$dest")" && run mv "$src" "$dest"
}

remove() {  # remove FILE REASON
  [[ -e $1 ]] || return 0
  plan "remove" "$1 ($2)"
  run rm -f "$1"
}

echo "== XDG moves"
move "$HOME/.docker"     "$XDG_CONFIG_HOME/docker"
move "$HOME/.rahi-keys"  "$XDG_DATA_HOME/keys/rahi-keys"
move "$HOME/go"          "$XDG_DATA_HOME/go"
move "$XDG_DATA_HOME/zsh/history" "$XDG_STATE_HOME/zsh/history"
[[ -d $XDG_DATA_HOME/keys ]] && run chmod 700 "$XDG_DATA_HOME/keys"

echo "== replaced dotfiles"
if grep -q ZDOTDIR /etc/zsh/zshenv 2>/dev/null && [[ -f $XDG_CONFIG_HOME/zsh/.zprofile ]]; then
  remove "$HOME/.zprofile" "now ~/.config/zsh/.zprofile"
else
  plan "wait" "$HOME/.zprofile stays until system-setup.sh has run and the new .zprofile is copied"
fi
grep -qx "$USER" /etc/hushlogins 2>/dev/null && remove "$HOME/.hushlogin" "/etc/hushlogins covers it"
[[ -f /etc/sudoers.d/90-naos-no-admin-flag ]] && remove "$HOME/.sudo_as_admin_successful" "sudo no longer writes it"
remove "$HOME/.fehbg" "xmonad runs feh with --no-fehbg"
if [[ -n ${XAUTHORITY:-} && $XAUTHORITY != "$HOME/.Xauthority" ]]; then
  remove "$HOME/.Xauthority" "X now uses \$XDG_RUNTIME_DIR/Xauthority"
else
  plan "wait" "$HOME/.Xauthority is in use; run this again after a reboot"
fi

echo "== loose files in ~ -> $PARKED"
for f in "$HOME"/*.png "$HOME"/*.jpg "$HOME"/esp-backup-*.tgz; do
  [[ -e $f ]] || continue
  if [[ -O $f ]]; then move "$f" "$PARKED/$(basename "$f")"
  else plan "sudo" "sudo mv '$f' '$PARKED/'   (owned by root)"; fi
done

echo "== installer backups (*.bak-YYYYMMDD-HHMMSS from the naos kit)"
while IFS= read -r -d '' f; do remove "$f" "old copy"; done < <(
  find "$XDG_CONFIG_HOME" "$HOME/.local/bin" -maxdepth 3 -type f \
    -name '*.bak-20[0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]' -print0 2>/dev/null)

echo "== dotfiles repo: README.md (edited in .config/readmedoc) and .gitignore stay in git only"
if [[ -d $DOTGIT ]]; then
  if [[ -f $HOME/.gitignore ]]; then
    plan "copy" "$HOME/.gitignore patterns -> $DOTGIT/info/exclude (git reads ignores there for a bare repo)"
    run mkdir -p "$DOTGIT/info"
    (( APPLY )) && { echo "# from ~/.gitignore (naos)"; cat "$HOME/.gitignore"; } >> "$DOTGIT/info/exclude"
  fi
  plan "hooks" "dot config core.hooksPath ~/.config/naos/setup/dot-hooks (root README follows .config/readmedoc/README.md)"
  run dot config core.hooksPath "$XDG_CONFIG_HOME/naos/setup/dot-hooks"
  plan "sparse" "dot sparse-checkout set --no-cone '/*' '!/README.md' '!/.gitignore'"
  run dot update-index -q --refresh                                # ignore metadata-only changes
  if (( APPLY )) && ! dot diff --quiet -- .gitignore 2>/dev/null; then
    plan "stop" ".gitignore has uncommitted edits; commit them, then run this again"
  else
    run dot sparse-checkout set --no-cone '/*' '!/README.md' '!/.gitignore'
  fi
else
  plan "skip" "no bare repo at $DOTGIT"
fi

echo "== can't move (the program hardcodes the path)"
for d in .ssh .pki .vscode .vscode-shared .ollama .copilot; do
  [[ -e $HOME/$d ]] && plan "keep" "$HOME/$d"
done

echo
if (( APPLY )); then echo "Done. Now ls -A ~ should show only the keep list plus .cache .config .local and Downloads."
else echo "This was the plan only. Run again with --apply to do it."; fi
