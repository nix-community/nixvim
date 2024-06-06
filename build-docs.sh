#!/usr/bin/env sh

set -ex

mkdir -p docs-build
nix build github:nix-community/nixvim#docs
cp -r result/share/doc/* docs-build
nix build github:nix-community/nixvim/nixos-24.05#docs
cp -r result/share/doc docs-build/stable
