{
  lib,
  pkgs,
  ...
} @ args:
with lib;
with (import ../helpers.nix {inherit lib;}).vim-plugin;
  mkVimPlugin args {
    name = "tagbar";
    package = pkgs.vimPlugins.tagbar;
    globalPrefix = "tagbar_";
    extraPackages = [pkgs.ctags];
  }
