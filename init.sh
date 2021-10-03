#!/bin/sh

git clone https://github.com/liuchengxu/space-vim.git ~/.space-vim
cd ~/.space-vim
make vim
make neovim
cd -

git clone https://github.com/nikita-skobov/create-bash-script ~/.local/share/create-bash-script
git clone https://gitea.theedgeofrage.com/TheEdgeOfRage/rpn ~/.local/share/rpn
git clone https://github.com/TheEdgeOfRage/bumblebee-status ~/.local/share/bumblebee-status

mkdir -p ~/.config/zsh/plugins/
git clone https://github.com/TheEdgeOfRage/ohmyzsh ~/.config/zsh/oh-my-zsh

git clone https://github.com/MichaelAquilina/zsh-you-should-use ~/.config/zsh/plugins/you-should-use
git clone https://github.com/TheEdgeOfRage/zsh-autoswitch-virtualenv ~/.config/zsh/plugins/autoswitch-virtualenv
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ~/.config/zsh/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.config/zsh/plugins/zsh-syntax-highlighting
