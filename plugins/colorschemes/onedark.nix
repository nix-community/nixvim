{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.colorschemes.onedark;
in {
  options = {
    colorschemes.onedark = {
      enable = mkEnableOption "onedark";

      package = helpers.mkPackageOption "one" pkgs.vimPlugins.onedark-vim;
    };
  };

  config = mkIf cfg.enable {
    colorscheme = "onedark";
    extraPlugins = [cfg.package];

    options = {
      termguicolors = true;
    };
  };
}
