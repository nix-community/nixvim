{
  lib,
  pkgs,
  ...
} @ attrs: let
  helpers = import ../helpers.nix {inherit lib;};
in
  with helpers;
  with lib;
    mkPlugin attrs {
      name = "nix";
      description = "Enable nix";
      package = pkgs.vimPlugins.vim-nix;

      # Possibly add option to disable Treesitter highlighting if this is installed
      options = {};
    }
