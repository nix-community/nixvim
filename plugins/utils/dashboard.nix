{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.plugins.dashboard;

  helpers = import ../helpers.nix { inherit lib; };
in
{
  options = {
    plugins.dashboard = {
      enable = mkEnableOption "Enable dashboard";

      package = {
        type = types.package;
        default = pkgs.vimPlugins.dashboard-nvim;
        description = "Plugin to use for dashboard-nvim";
      };

      header = mkOption {
        description = "Header text";
        type = types.nullOr (types.listOf types.str);
        default = null;
      };

      footer = mkOption {
        description = "Footer text";
        type = types.nullOr (types.listOf types.str);
        default = null;
      };

      center = mkOption {
        description = "Center section";
        type = types.nullOr (types.listOf (types.submodule {
          options = {
            icon = mkOption {
              description = "Item icon";
              type = types.nullOr types.str;
              default = null;
            };

            desc = mkOption {
              description = "Item description";
              type = types.str;
            };

            shortcut = mkOption {
              description = "Item shortcut";
              type = types.nullOr types.str;
              default = null;
            };

            action = mkOption {
              description = "Item action";
              type = types.nullOr types.str;
              default = null;
            };
          };
        }));
        default = null;
      };

      sessionDirectory = mkOption {
        description = "Path to session file";
        type = types.nullOr types.str;
        default = null;
      };

      preview = mkOption {
        description = "Preview options";
        type = types.submodule {
          options = {
            command = mkOption {
              description = "Command to print file contents";
              type = types.nullOr types.str;
              default = null;
            };

            file = mkOption {
              description = "Path to preview file";
              type = types.nullOr types.str;
              default = null;
            };

            height = mkOption {
              description = "The height of the preview file";
              type = types.nullOr types.int;
              default = null;
            };

            width = mkOption {
              description = "The width of the preview file";
              type = types.nullOr types.int;
              default = null;
            };
          };
        };
        default = { };
      };

      hideStatusline = mkOption {
        description = "Whether to hide statusline in Dashboard buffer";
        type = types.nullOr types.bool;
        default = null;
      };

      hideTabline = mkOption {
        description = "Whether to hide tabline in Dashboard buffer";
        type = types.nullOr types.bool;
        default = null;
      };
    };
  };

  config =
    let
      options = {
        custom_header = cfg.header;
        custom_footer = cfg.footer;
        custom_center = cfg.center;

        preview_file_path = cfg.preview.file;
        preview_file_height = cfg.preview.height;
        preview_file_width = cfg.preview.width;
        preview_command = cfg.preview.command;

        hide_statusline = cfg.hideStatusline;
        hide_tabline = cfg.hideTabline;

        session_directory = cfg.sessionDirectory;
      };

      filteredOptions = filterAttrs (_: v: !isNull v) options;
    in
    mkIf cfg.enable {
      extraPlugins = [ cfg.package ];
      extraConfigLua = ''
        local dashboard = require("dashboard")

        ${toString (mapAttrsToList (n: v:
          "dashboard.${n} = ${helpers.toLuaObject v}\n")
          filteredOptions)}
      '';
    };
}
