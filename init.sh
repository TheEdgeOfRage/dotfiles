#!/bin/sh

git clone https://github.com/TheEdgeOfRage/bumblebee-status ~/.local/share/bumblebee-status

go install gitea.theedgeofrage.com/theedgeofrage/rpn

ohmyzsh_dir="$HOME/.config/zsh/oh-my-zsh"
ohmyzsh_custom="${ohmyzsh_dir}/custom"
git clone https://github.com/TheEdgeOfRage/ohmyzsh ${ohmyzsh_dir}
git clone https://github.com/MichaelAquilina/zsh-you-should-use ${ohmyzsh_custom}/plugins/you-should-use
git clone https://github.com/TheEdgeOfRage/zsh-autoswitch-virtualenv ${ohmyzsh_custom}/plugins/zsh-autoswitch-virtualenv
git clone https://github.com/zsh-users/zsh-autosuggestions ${ohmyzsh_custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ohmyzsh_custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ohmyzsh_custom}/plugins/zsh-syntax-highlighting
git clone https://gitea.theedgeofrage.com/TheEdgeOfRage/boban-zsh ${ohmyzsh_custom}/themes/boban

sudo cp ./custom_colemak /usr/share/X11/xkb/symbols/custom

sudo pacman -S gcr
systemctl enable --now gcr-ssh-agent.socket
