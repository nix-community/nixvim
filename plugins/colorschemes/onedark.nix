{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.colorschemes.onedark;
in {
  options = {
    programs.nixvim.colorschemes.onedark = {
      enable = mkEnableOption "Enable onedark";
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      colorscheme = "onedark";
      extraPlugins = [ pkgs.vimPlugins.onedark-vim ];

      options = {
        termguicolors = true;
      };
    };
  };
}
