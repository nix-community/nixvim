{ pkgs, config, lib, ... }:
with lib;
let cfg = config.programs.nixvim.colorschemes.tokyonight;
in {
  options = {
    programs.nixvim.colorschemes.tokyonight = {
      enable = mkEnableOption "Enable tokyonight";
    };
  };
  config = mkIf cfg.enable {
    programs.nixvim = {
      colorscheme = "tokyonight";
      extraPlugins = [ pkgs.vimPlugins.tokyonight-nvim ];
      options = { termguicolors = true; };
    };
  };
}
