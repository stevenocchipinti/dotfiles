#!/bin/bash

set -ex

# Setup dotfiles
sudo pacman -S chezmoi --needed --noconfirm
chezmoi --source ~/.dotfiles apply

# The important stuff
sudo pacman -S \
  yay fish git neovim \
  --needed --noconfirm

# Better tools
sudo pacman -S \
  zoxide fzf eza bat fd git-delta ripgrep docker ghostty \
  ttf-cascadia-code-nerd \
  --needed --noconfirm

# AUR
yay -S \
  ghostty visual-studio-code \
  --needed --noconfirm

# NodeJS
curl -fsSL https://fnm.vercel.app/install | SHELL=/bin/fish bash
fish --command="fnm install --lts"
