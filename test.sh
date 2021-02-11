#!/usr/bin/env sh
# Creates a container and then runs the resulting neovim executable with the configuration
set -e

sudo nixos-container destroy nvim-test
sudo nixos-container create nvim-test --flake .

.tmp/sw/bin/nvim -u .tmp/etc/xdg/nvim/sysinit.vim $@
