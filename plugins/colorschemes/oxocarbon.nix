{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.colorschemes.oxocarbon;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options = {
    colorschemes.oxocarbon = {
      enable = mkEnableOption "oxocarbon";

      package = helpers.mkPackageOption "one" pkgs.vimPlugins.oxocarbon-nvim;
    };
  };

  config = mkIf cfg.enable {
    colorscheme = "oxocarbon";
    extraPlugins = [cfg.package];

    options = {
      termguicolors = true;
    };
  };
}
