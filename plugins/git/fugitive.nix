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
      name = "fugitive";
      description = "vim-fugitive";
      package = pkgs.vimPlugins.vim-fugitive;
      extraPackages = [pkgs.git];

      # In typical tpope fashion, this plugin has no config options
      options = {};
    }
