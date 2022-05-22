#!/bin/bash

# Set some vars
TARGET_WORK_TREE=$HOME/Code/System/dotfiles
GIT_DIR=$HOME/.dotfiles/
GIT_CMD="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME/Code/System/dotfiles"

# For reference, with bare repo can change symbolic ref with:
# dotfiles symbolic-ref HEAD refs/heads/branchname

# Go to the target location to begin migrating all files
cd $TARGET_WORK_TREE

# This is a bit manual, but I can just manage this list manually since it shouldn't change super often
cp $HOME/.bashrc bashrc
cp $HOME/.config/nvim/init.lua vimrc.lua
cp -a $HOME/.dotfiles/aux/ ./scripts/
rm ./scripts/README.md
cp $HOME/.dotfiles/aux/README.md README.md
cp $HOME/.gitconfig gitconfig
cp $HOME/.tmux.conf tmux.conf
cp $HOME/.config/alacritty/alacritty.yml alacritty.yml
