{
  lib,
  helpers,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkDefault mkIf;
  cfg = config.colorschemes.melange;
in {
  options = {
    colorschemes.melange = {
      enable = mkEnableOption "Melange colorscheme";
      package = helpers.mkPackageOption "melange.nvim" pkgs.vimPlugins.melange-nvim;
    };
  };

  config = mkIf cfg.enable {
    colorscheme = "melange";
    extraPlugins = [cfg.package];
    opts.termguicolors = mkDefault true;
  };
}
