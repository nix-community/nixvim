{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkDefault mkIf;
  inherit (import ../helpers.nix {inherit lib;}) mkPackageOption;
  cfg = config.colorschemes.melange;
in {
  options = {
    colorschemes.melange = {
      enable = mkEnableOption "Melange colorscheme";
      package = mkPackageOption "melange.nvim" pkgs.vimPlugins.melange-nvim;
    };
  };

  config = mkIf cfg.enable {
    colorscheme = "melange";
    extraPlugins = [cfg.package];
    options = {
      termguicolors = mkDefault true;
    };
  };
}
