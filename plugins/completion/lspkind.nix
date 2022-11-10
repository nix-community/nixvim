{ config, pkgs, lib, helpers, ... }:
with lib;
let
  cfg = config.plugins.lspkind;
in
{
  options.plugins.lspkind = {
    enable = mkEnableOption "lspkind.nvim";
    mode = mkOption {
      type = with types; nullOr (enum [ "text" "text_symbol" "symbol_text" "symbol" ]);
      default = null;
      description = "Defines how annotations are shown";
    };

    preset = mkOption {
      type = with types; nullOr (enum [ "default" "codicons" ]);
      default = null;
      description = "Default symbol map";
    };

    symbolMap = mkOption {
      type = with types; nullOr (attrsOf str);
      default = null;
      description = "Override preset symbols";
    };

    cmp = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Integrate with nvim-cmp";
      };

      maxWidth = mkOption {
        type = with types; nullOr int;
        default = null;
        description = "Maximum number of characters to show in the popup";
      };

      ellipsisChar = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "Character to show when the popup exceeds maxwidth";
      };
    };
  };

  config =
    let
      doCmp = cfg.cmp.enable && config.plugins.nvim-cmp.enable;
      options = {
        mode = cfg.mode;
        preset = cfg.preset;
        symbol_map = cfg.symbolMap;
      } // (if doCmp then {
        maxwidth = cfg.cmp.maxWidth;
        ellipsis_char = cfg.cmp.ellipsisChar;
      } else { });
    in
    mkIf cfg.enable {
      extraPlugins = [ pkgs.vimPlugins.lspkind-nvim ];

      extraConfigLua = optionalString (!doCmp) ''
        require('lspkind').init(${helpers.toLuaObject options})
      '';

      plugins.nvim-cmp.formatting.format = ''
        require('lspkind').cmp_format(${helpers.toLuaObject options})
      '';
    };
}
