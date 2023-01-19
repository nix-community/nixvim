{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.colorschemes.onedark;
in
{
  options = {
    colorschemes.onedark = {
      enable = mkEnableOption "Enable onedark";

      package = mkOption {
        type = types.package;
        default = pkgs.vimPlugins.onedark-vim;
        description = "Plugin to use for one";
      };
    };
  };

  config = mkIf cfg.enable {
    colorscheme = "onedark";
    extraPlugins = [ cfg.package ];

    options = {
      termguicolors = true;
    };
  };
}
