#!/bin/bash
#
# init.sh
# Copyright (C) 2020 pavle <pavle.portic@tilda.center>
#
# Distributed under terms of the BSD 3-Clause license.
#

curl -L git.io/antigen > ~/.local/share/antigen.zsh

git clone https://github.com/liuchengxu/space-vim.git ~/.space-vim
cd ~/.space-vim
make vim
make neovim
cd -

git clone https://github.com/nikita-skobov/create-bash-script ~/.local/share/create-bash-script
git clone https://gitlab.theedgeofrage.com/TheEdgeOfRage/rpn ~/.local/share/rpn
git clone https://github.com/tobi-wan-kenobi/bumblebee-status ~/.local/share/bumblebee-status
