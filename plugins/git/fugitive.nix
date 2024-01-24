{
  lib,
  pkgs,
  ...
} @ attrs: let
  helpers = import ../helpers.nix {inherit lib;};
in
  with helpers.vim-plugin;
  with lib;
    mkPlugin attrs {
      name = "fugitive";
      description = "Enable vim-fugitive";
      package = pkgs.vimPlugins.vim-fugitive;
      extraPackages = [pkgs.git];

      # In typical tpope fashion, this plugin has no config options
      options = {};
    }
