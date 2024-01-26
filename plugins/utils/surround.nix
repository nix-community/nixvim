{
  lib,
  pkgs,
  ...
} @ attrs: let
  helpers = import ../helpers.nix {inherit lib;};
in
  with helpers.vim-plugin;
  with lib;
    mkVimPlugin attrs {
      name = "surround";
      description = "surround.vim";
      package = pkgs.vimPlugins.surround;

      options = {};
    }
