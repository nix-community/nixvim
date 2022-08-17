{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.trouble;

  helpers = import ../helpers.nix { inherit lib config; };
in
{
  options = {
    programs.nixvim.plugins.trouble = {
      enable = mkEnableOption "Enable trouble.nvim";

      position = mkOption {
        description = "position of the list";
        type = types.enum [ "bottom" "top" "left" "right" ];
        default = "bottom";
      };

      # TODO: other options from https://github.com/folke/trouble.nvim

    };
  };

  config =
    let
      options = {
        position = cfg.position;
      };

      filteredOptions = filterAttrs (_: v: !isNull v) options;
    in mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = [ pkgs.vimPlugins.trouble-nvim ];
      extraConfigLua = ''
        require("trouble").setup${helpers.toLuaObject filteredOptions}
      '';
    };
  };
}
