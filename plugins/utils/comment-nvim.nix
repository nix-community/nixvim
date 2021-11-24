{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.comment-nvim;
  helpers = import ../helpers.nix { inherit lib; };
in
{
  options = {
    programs.nixvim.plugins.comment-nvim = {
      enable = mkEnableOption "Enable comment-nvim";
      padding = mkOption {
        type = types.nullOr types.bool;
        description = "Add a space b/w comment and the line";
        default = null;
      };
      sticky = mkOption {
        type = types.nullOr types.bool;
        description = "Whether the cursor should stay at its position";
        default = null;
      };
      ignore = mkOption {
        type = types.nullOr types.str;
        description = "Lines to be ignored while comment/uncomment";
        default = null;
      };
      toggler = mkOption {
        type = types.nullOr (types.submodule ({...}: {
          options = {
            line = mkOption {
              type = types.str;
              description = "line-comment keymap";
              default = "gcc";
            };
            block = mkOption {
              type = types.str;
              description = "block-comment keymap";
              default = "gbc";
            };
          };
        }));
        description = "LHS of toggle mappings in NORMAL + VISUAL mode";
        default = null;
      };
      opleader = mkOption {
        type = types.nullOr (types.submodule ({...}: {
          options = {
            line = mkOption {
              type = types.str;
              description = "line-comment keymap";
              default = "gc";
            };
            block = mkOption {
              type = types.str;
              description = "block-comment keymap";
              default = "gb";
            };
          };
        }));
        description = "LHS of operator-pending mappings in NORMAL + VISUAL mode";
        default = null;
      };
      mappings = mkOption {
        type = types.nullOr (types.submodule ({...}: {
          options = {
            basic = mkOption {
              type = types.bool;
              description = "operator-pending mapping. Includes 'gcc', 'gcb', 'gc[count]{motion}' 
              and 'gb[count]{motion}'";
              default = true;
            };
            extra = mkOption {
              type = types.bool;
              description = "extra mapping. Includes 'gco', 'gc0', 'gcA'";
              default = true;
            };
            extended = mkOption {
              type = types.bool;
              description = "extended mapping. Includes 'g>', 'g<', 'g>[count]{motion}' and 
              'g<[count]{motion}'";
              default = false;
            };
          };
        }));
        description = "Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode";
        default = null;
      };
    };
  };

  config = let
    setupOptions = {
      padding = cfg.padding;
      sticky = cfg.sticky;
      ignore = cfg.ignore;
      toggler = cfg.toggler;
      opleader = cfg.opleader;
      mappings = cfg.mappings;
    };
    in mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = [ pkgs.vimPlugins.comment-nvim ];
      extraConfigLua =
        ''require("Comment").setup${helpers.toLuaObject setupOptions}'';
    };
  };
}
