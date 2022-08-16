{ config, pkgs, lib, ... }:
with lib;
let

  name = "tabby";

  cfg = config.programs.nixvim.plugins.${name};
  helpers = import ../helpers.nix { inherit lib; };

  highlight = mkOption {
    type = types.nullOr (types.submodule ({ ... }: {
      options = {
        guifg = mkOption {
          type = types.nullOr types.str;
          description = "foreground color";
          default = null;
        };
        guibg = mkOption {
          type = types.nullOr types.str;
          description = "background color";
          default = null;
        };
      };
    }));
    default = null;
  };
in with helpers;
{
  options = {
    programs.nixvim.plugins.${name} = {
      enable = mkEnableOption "Enable ${name}";

      presets = {
        activeWinsAtTall = boolOption;
        activeWinsAtEnd = boolOption;
        tabWithTopWin = boolOption;
        activeTabWithWins = boolOption;
        tabOnly = boolOption;
      };
    };
  };

  config = let 
    setupOptions = {
      options = {
        # presets = {
        #   active_wins_at_tall = cfg.presets.activeWinsAtTall;
        # };
      };
    };
    in mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = with pkgs.vimExtraPlugins; [
        tabby-nvim
      ];
      extraConfigLua = ''
        require('tabby').setup${helpers.toLuaObject setupOptions}
      '';
    };
  };
}
