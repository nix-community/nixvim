{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.focus;
  helpers = (import ../helpers.nix { inherit lib; });
in
{
  options.programs.nixvim.plugins.focus = {
    enable = mkEnableOption "Enable focus.nvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = [
        pkgs.vimExtraPlugins.focus-nvim
      ];

      extraConfigLua = ''
        require('focus').setup{ }
      '' ;
    };
  };
}
