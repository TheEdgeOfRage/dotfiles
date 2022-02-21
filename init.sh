#!/bin/sh

git clone https://github.com/liuchengxu/space-vim.git ~/.space-vim
cd ~/.space-vim
make vim
make neovim
cd -


git clone https://github.com/nikita-skobov/create-bash-script ~/.local/share/create-bash-script
git clone https://gitea.theedgeofrage.com/TheEdgeOfRage/rpn ~/.local/share/rpn
git clone https://github.com/TheEdgeOfRage/bumblebee-status ~/.local/share/bumblebee-status

local ohmyzsh_custom="~/.config/zsh/oh-my-zsh/custom"
git clone https://github.com/TheEdgeOfRage/ohmyzsh ~/.config/zsh/oh-my-zsh
git clone https://github.com/MichaelAquilina/zsh-you-should-use ${ohmyzsh_custom}/plugins/you-should-use
git clone https://github.com/TheEdgeOfRage/zsh-autoswitch-virtualenv ${ohmyzsh_custom}/plugins/zsh-autoswitch-virtualenv
git clone https://github.com/zsh-users/zsh-autosuggestions ${ohmyzsh_custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ohmyzsh_custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ohmyzsh_custom}/plugins/zsh-syntax-highlighting
