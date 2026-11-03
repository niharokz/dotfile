#!/usr/bin/env bash
# naos system setup (one time, needs sudo). Safe to run again: every step checks before changing.
#   1. zsh reads its config from ~/.config/zsh   (no ~/.zprofile)
#   2. sudo stops creating ~/.sudo_as_admin_successful
#   3. login messages stay hidden without ~/.hushlogin
#   4. Edge is the system browser (x-www-browser)
#   5. packages the new configs use
# Lives in the dotfiles repo at ~/.config/naos/setup/. Usage: sudo bash ~/.config/naos/setup/system-setup.sh
set -euo pipefail

[[ $EUID -eq 0 ]] || { echo "Run with sudo"; exit 1; }
USER_NAME=${SUDO_USER:?run with sudo from your normal user}
ok()   { echo "  ✓ $*"; }
did()  { echo "  → $*"; }

echo "== 1. ZDOTDIR for zsh"
ZSHENV=/etc/zsh/zshenv
if grep -q 'ZDOTDIR=' "$ZSHENV" 2>/dev/null; then ok "already set in $ZSHENV"
else
  # shellcheck disable=SC2016  # written literally; $HOME expands when zsh starts
  printf '\n# XDG: per-user zsh files live in ~/.config/zsh (naos)\n[[ -z $ZDOTDIR ]] && export ZDOTDIR="$HOME/.config/zsh"\n' >> "$ZSHENV"
  did "added ZDOTDIR to $ZSHENV"
fi

echo "== 2. no ~/.sudo_as_admin_successful"
DROP=/etc/sudoers.d/90-naos-no-admin-flag
if [[ -f $DROP ]]; then ok "already in $DROP"
else
  tmp=$(mktemp); echo 'Defaults !admin_flag' > "$tmp"
  if visudo -cf "$tmp" >/dev/null; then install -m 440 "$tmp" "$DROP"; did "added $DROP"
  else echo "  ! visudo rejected the rule, skipped"; fi
  rm -f "$tmp"
fi

echo "== 3. hushed login without ~/.hushlogin"
if grep -qE '^HUSHLOGIN_FILE[[:space:]]+/etc/hushlogins' /etc/login.defs; then ok "login.defs already uses /etc/hushlogins"
else
  cp -a /etc/login.defs "/etc/login.defs.bak-$(date +%Y%m%d)"
  if grep -qE '^HUSHLOGIN_FILE' /etc/login.defs; then               # change the active line only, not the commented examples
    sed -i -E 's|^HUSHLOGIN_FILE.*|HUSHLOGIN_FILE\t/etc/hushlogins|' /etc/login.defs
  else
    printf 'HUSHLOGIN_FILE\t/etc/hushlogins\n' >> /etc/login.defs
  fi
  did "login.defs -> HUSHLOGIN_FILE /etc/hushlogins (backup kept)"
fi
grep -qx "$USER_NAME" /etc/hushlogins 2>/dev/null || { echo "$USER_NAME" >> /etc/hushlogins; did "added $USER_NAME to /etc/hushlogins"; }

echo "== 4. Edge as the system browser"
EDGE=$(command -v microsoft-edge-stable || true)
if [[ -z $EDGE ]]; then echo "  ! microsoft-edge-stable not found, skipped"
else
  for alt in x-www-browser gnome-www-browser; do
    if update-alternatives --list "$alt" 2>/dev/null | grep -qx "$EDGE"; then
      update-alternatives --set "$alt" "$EDGE" >/dev/null && did "$alt -> $EDGE"
    fi
  done
fi

echo "== 5. packages"
for pkg in dunst libnotify-bin eza zsh-autosuggestions zsh-syntax-highlighting; do
  if dpkg -s "$pkg" >/dev/null 2>&1; then ok "$pkg"
  elif apt-get install -y -q "$pkg" >/dev/null 2>&1; then did "installed $pkg"
  else echo "  ! could not install $pkg"; fi
done

echo
echo "Done. Next: bash ~/.config/naos/setup/migrate-home.sh"
