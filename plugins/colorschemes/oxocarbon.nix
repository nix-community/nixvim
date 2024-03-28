{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.colorschemes.oxocarbon;
in {
  options = {
    colorschemes.oxocarbon = {
      enable = mkEnableOption "oxocarbon";

      package = helpers.mkPackageOption "oxocarbon" pkgs.vimPlugins.oxocarbon-nvim;
    };
  };

  config = mkIf cfg.enable {
    colorscheme = "oxocarbon";
    extraPlugins = [cfg.package];

    opts.termguicolors = mkDefault true;
  };
}
