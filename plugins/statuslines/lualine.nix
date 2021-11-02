{ pkgs, config, lib, ... }:
with lib;
let cfg = config.programs.nixvim.plugins.lualine;
in {
  options = {
    programs.nixvim.plugins.lualine = {
      enable = mkEnableOption "Enable airline";
    };
  };
  if mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = with pkgs.vimPlugins.lualine-nvim;
    };
  };
}
