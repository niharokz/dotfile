# Nihar’s Dotfiles

Dotfiles for XMonad, Xmobar, Kitty, Neovim, and related tools.  
Runs seamlessly across **Arch Linux** and **Debian**, on multiple machines.

---

## 📦 Requirements

Install these before checkout:

### Core
- xmonad
- xmonad-contrib
- xmobar
- kitty
- neovim
- picom
- feh
- dmenu
- xdotool

### Extras
- flameshot
- pactl (PulseAudio)
- nm-connection-editor
- brave-browser or microsoft-edge-stable

### Fonts
- FiraCode Nerd Font  
- Font Awesome (for xmobar icons)

---

## 🐧 Installation

### Arch Linux
\`\`\`bash
sudo pacman -S xmonad xmonad-contrib xmobar kitty neovim picom feh dmenu xdotool flameshot pulseaudio
\`\`\`

### Debian / Ubuntu
\`\`\`bash
sudo apt install xmonad libghc-xmonad-contrib-dev xmobar kitty neovim picom feh dmenu xdotool flameshot pulseaudio
\`\`\`

---

## 🚀 Fresh Install

Clone the repo as a **bare repository**:

\`\`\`bash
git clone --bare git@gitlab.com:niharokz/dotfile.git \$HOME/.config/.dotfile
\`\`\`

Define the alias:

\`\`\`bash
alias dot='/usr/bin/git --git-dir=\$HOME/.config/.dotfile --work-tree=\$HOME'
\`\`\`

Checkout the files:

\`\`\`bash
dot checkout
\`\`\`

Hide untracked files:

\`\`\`bash
dot config status.showUntrackedFiles no
\`\`\`

---

## 🔄 Reinstall / Migration

Remove old configs:

\`\`\`bash
rm -rf ~/.config/xmonad ~/.config/xmobar ~/.config/kitty ~/.config/nvim
\`\`\`

Re-run the checkout steps above.

Reinstall fonts (Nerd Fonts + Font Awesome), then refresh:

\`\`\`bash
fc-cache -fv
\`\`\`

---

## ⚙️ Post-Install Checklist

Fonts – Verify icons render in xmobar:
\`\`\`bash
fc-list | grep Nerd
fc-list | grep Awesome
\`\`\`

Xmobar – Ensure %UnsafeStdinReader% is present in .xmobarrc.

Wallpaper – Update the feh line in xmonad.hs to your preferred path.

Volume Keys – Adjust multimedia key mappings if hardware differs.

Network – Use:
\`\`\`bash
nm-connection-editor
\`\`\`
or
\`\`\`bash
nmtui
\`\`\`

---

## 📝 Notes

- Works on both Arch and Debian  
- Configs are modular — managed via the bare Git repo (dot alias)  
- Scratchpads, gaps, spacing, and workspace icons are pre-configured  

---

## 📚 References

https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/
EOF

