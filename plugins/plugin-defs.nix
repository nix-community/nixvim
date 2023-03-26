# This is for plugins not in nixpkgs
# e.g. intellitab.nvim
#
# This is generated through nvfetcher, the plugins are defined in nvfetcher.toml.
# You can update the plugins by running `nvfetcher` in this directory
{pkgs, ...}: let
  sources = pkgs.callPackage ./_sources/generated.nix {};
in {}
