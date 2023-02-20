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
      name = "fugitive";
      description = "Enable vim-fugitive";
      package = pkgs.vimPlugins.vim-fugitive;
      extraPackages = [pkgs.git];

      # In typical tpope fashin, this plugin has no config options
      options = {};
    }
