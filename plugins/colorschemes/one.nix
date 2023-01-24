{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.colorschemes.one;
  helpers = import ../helpers.nix { inherit lib; };
in
{
  options = {
    colorschemes.one = {
      enable = mkEnableOption "vim-one";

      package = helpers.mkPackageOption "one" pkgs.vimPlugins.vim-one;
    };
  };

  config = mkIf cfg.enable {
    colorscheme = "one";
    extraPlugins = [ cfg.package ];

    options = {
      termguicolors = true;
    };
  };
}
