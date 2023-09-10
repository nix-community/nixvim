{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.colorschemes.dracula;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options = {
    colorschemes.dracula = {
      enable = mkEnableOption "dracula";

      package = helpers.mkPackageOption "dracula" pkgs.vimPlugins.dracula-vim;
    };
  };

  config = mkIf cfg.enable {
    colorscheme = "dracula";
    extraPlugins = [cfg.package];

    options = {
      termguicolors = mkDefault true;
    };
  };
}
