{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.colorschemes.base16;
  helpers = import ../helpers.nix { inherit lib; };
  themes = import ./base16-list.nix;
in
{
  options = {
    colorschemes.base16 = {
      enable = mkEnableOption "base16";

      package = helpers.mkPackageOption "base16" pkgs.vimPlugins.base16-vim;

      useTruecolor = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to use truecolor for the colorschemes. If set to false, you'll need to set up base16 in your shell.";
      };

      colorscheme = mkOption {
        type = types.enum themes;
        description = "The base16 colorscheme to use";
        default = head themes;
      };

      setUpBar = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to install the matching plugin for your statusbar. This does nothing as of yet, waiting for upstream support.";
      };
    };
  };

  config = mkIf cfg.enable {
    colorscheme = "base16-${cfg.colorscheme}";
    extraPlugins = [ cfg.package ];

    plugins.airline.theme = mkIf (cfg.setUpBar) "base16";
    plugins.lightline.colorscheme = null;

    options.termguicolors = mkIf cfg.useTruecolor true;
  };
}
