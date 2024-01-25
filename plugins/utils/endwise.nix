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
      name = "endwise";
      description = "Enable vim-endwise";
      package = pkgs.vimPlugins.vim-endwise;

      # Yes it's really not configurable
      options = {};
    }
