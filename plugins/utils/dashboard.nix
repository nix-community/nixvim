{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.dashboard;
in {
  options = {
    plugins.dashboard = {
      enable = mkEnableOption "dashboard";

      package = helpers.mkPackageOption "dashboard" pkgs.vimPlugins.dashboard-nvim;

      theme = mkOption {
        description = "Dashboard theme";
        type = with types; oneOf [(enum ["hyper"]) (enum ["doom"])];
        default = "hyper";
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

            key = mkOption {
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
        default = {};
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

      hideWinbar = mkOption {
        description = "Whether to hide winbar in Dashboard buffer";
        type = types.nullOr types.bool;
        default = null;
      };
    };
  };

  config = let
    options = {
      theme = cfg.theme;

      config = {
        shortcut = if cfg.theme == "doom" then cfg.center else null;

        center = if cfg.theme == "hyper" then cfg.center else null;
        footer = if cfg.theme == "hyper" then cfg.footer else null;
      };

      hide = {
        statusline = cfg.hideStatusline;
        tabline = cfg.hideTabline;
        winbar = cfg.hideWinbar;
      };

      preview = {
        command = cfg.preview.command;
        file_height = cfg.preview.height;
        file_path = cfg.preview.file;
        file_width = cfg.preview.width;
      };
    };

    filteredOptions = filterAttrs (_: v: v != null) options;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];
      extraConfigLua = ''
        require("dashboard").setup {
          ${toString (mapAttrsToList (n: v: "${n} = ${helpers.toLuaObject v},\n")
              filteredOptions)}
        }
      '';
    };
}
