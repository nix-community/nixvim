{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.colorschemes.one;
in {
  options = {
    colorschemes.one = {
      enable = mkEnableOption "Enable vim-one";
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      colorscheme = "one";
      extraPlugins = [ pkgs.vimPlugins.vim-one ];

      options = {
        termguicolors = true;
      };
    };
  };
}
