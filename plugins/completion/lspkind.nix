{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.plugins.lspkind;
  helpers = import ../helpers.nix { inherit lib; };
in
{
  options.plugins.lspkind = {
    enable = mkEnableOption "lspkind.nvim";

    package = helpers.mkPackageOption "lspkind" pkgs.vimPlugins.lspkind-nvim;

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

      menu = mkOption {
        type = with types; nullOr (attrsOf str);
        default = null;
        description = "Show source names in the popup";
      };

      after = mkOption {
        type = with types; nullOr types.str;
        default = null;
        description = "Function to run after calculating the formatting. function(entry, vim_item, kind)";
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
        menu = cfg.cmp.menu;
      } else { });
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];

      extraConfigLua = optionalString (!doCmp) ''
        require('lspkind').init(${helpers.toLuaObject options})
      '';

      plugins.nvim-cmp.formatting.format =
        if cfg.cmp.after != null then ''
          function(entry, vim_item)
            local kind = require('lspkind').cmp_format(${helpers.toLuaObject options})(entry, vim_item)

            return (${cfg.cmp.after})(entry, vim_after, kind)
          end
        '' else ''
          require('lspkind').cmp_format(${helpers.toLuaObject options})
        '';
    };
}
