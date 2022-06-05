{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.colorschemes.onedark;
in
{
  options = {
    colorschemes.onedark = {
      enable = mkEnableOption "Enable onedark";
    };
  };

  config = mkIf cfg.enable {
    colorscheme = "onedark";
    extraPlugins = [ pkgs.vimPlugins.onedark-vim ];

    options = {
      termguicolors = true;
    };
  };
}
