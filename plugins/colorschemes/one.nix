{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.colorschemes.one;
in {
  options = {
    programs.nixvim.colorschemes.one = {
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
