{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.comment-nvim;
  helpers = import ../helpers.nix {inherit lib;};
in {
  options = {
    plugins.comment-nvim = {
      enable = mkEnableOption "Enable comment-nvim";

      package = helpers.mkPackageOption "comment-nvim" pkgs.vimPlugins.comment-nvim;

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
        type = types.nullOr (types.submodule (_: {
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
        type = types.nullOr (types.submodule (_: {
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
        type = types.nullOr (types.submodule (_: {
          options = {
            basic = mkOption {
              type = types.bool;
              description = "operator-pending mapping. Includes 'gcc', 'gcb', 'gc[count]{motion}' and 'gb[count]{motion}'";
              default = true;
            };
            extra = mkOption {
              type = types.bool;
              description = "extra mapping. Includes 'gco', 'gc0', 'gcA'";
              default = true;
            };
            extended = mkOption {
              type = types.bool;
              description = "extended mapping. Includes 'g&gt;', 'g&lt;', 'g&gt;[count]{motion}' and 'g&lt;[count]{motion}'";
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
      inherit (cfg) padding sticky ignore toggler opleader mappings;
    };
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];
      extraConfigLua = ''require("Comment").setup${helpers.toLuaObject setupOptions}'';
    };
}
