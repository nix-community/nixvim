{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.plugins.dashboard;

  shortcutType = types.submodule {
    options.icon = mkOption {
      description = "The icon to display";
      type = types.nullOr types.str;
      default = null;
    };
    options.desc = mkOption {
      description = "The text to display";
      type = types.nullOr types.str;
      default = null;
    };
    options.key = mkOption {
      description = "The shortcut key to assign";
      type = types.nullOr types.str;
      default = null;
    };
    options.group = mkOption {
      description = "The highlight group to set";
      type = types.nullOr types.str;
      default = null;
    };
    options.action = mkOption {
      description = "The command to run when chosen";
      type = types.nullOr types.str;
      default = null;
    };
  };
in {
  imports = [
    (lib.mkRenamedOptionModule ["plugins" "dashboard" "hideStatusline"] ["plugins" "dashboard" "hide" "statusline"])
    (lib.mkRenamedOptionModule ["plugins" "dashboard" "hideTabline"] ["plugins" "dashboard" "hide" "tabline"])
    (lib.mkRemovedOptionModule ["plugins" "dashboard" "sessionDirectory"] ''
      dashboard-nvim no longer provides session support.
    '')
  ];

  options = {
    plugins.dashboard = {
      enable = mkEnableOption "dashboard";

      package = helpers.mkPackageOption "dashboard" pkgs.vimPlugins.dashboard-nvim;

      theme = mkOption {
        description = "The theme to use";
        type = types.nullOr (types.enum ["hyper" "doom"]);
        default = null;
      };

      header = mkOption {
        description = "Header text";
        type = types.nullOr (types.either (types.listOf types.str) helpers.nixvimTypes.rawLua);
        default = null;
      };

      footer = mkOption {
        description = "Footer text";
        type = types.nullOr (types.either (types.listOf types.str) helpers.nixvimTypes.rawLua);
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

      changeToVcsRoot = mkOption {
        type = types.nullOr types.bool;
        description = "For open file in hyper mru. It will change to the root of vcs";
        default = null;
      };

      disableMove = mkOption {
        type = types.nullOr types.bool;
        description = "Disable the move keymap for hyper";
        default = null;
      };

      hide = {
        statusline = mkOption {
          description = "Whether to hide statusline in Dashboard buffer";
          type = types.nullOr types.bool;
          default = null;
        };

        tabline = mkOption {
          description = "Whether to hide tabline in Dashboard buffer";
          type = types.nullOr types.bool;
          default = null;
        };

        winbar = mkOption {
          description = "Whether to hide winbar in Dashboard buffer";
          type = types.nullOr types.bool;
          default = null;
        };
      };

      packages.enable = mkOption {
        description = "Whether to display installed Vim packages";
        type = types.nullOr types.bool;
        default = null;
      };

      week_header.enable = mkOption {
        description = "Whether to display the week day header";
        type = types.nullOr types.bool;
        default = null;
      };

      project = {
        enable = mkOption {
          description = "Whether to display projects in hyper";
          type = types.nullOr types.bool;
          default = null;
        };

        icon = mkOption {
          description = "The icon to display";
          type = types.nullOr types.str;
          default = null;
        };

        label = mkOption {
          description = "The text to display";
          type = types.nullOr types.str;
          default = null;
        };

        limit = mkOption {
          description = "The max amount of projects to show";
          type = types.nullOr types.int;
          default = null;
        };

        action = mkOption {
          description = "The command to run when selecting a project";
          type = types.nullOr types.str;
          default = null;
        };
      };

      mru = {
        icon = mkOption {
          description = "The icon to display";
          type = types.nullOr types.str;
          default = null;
        };

        label = mkOption {
          description = "The text to display";
          type = types.nullOr types.str;
          default = null;
        };

        limit = mkOption {
          description = "The max amount of projects to show";
          type = types.nullOr types.int;
          default = null;
        };
      };

      shortcut = mkOption {
        description = "Shortcuts to display";
        type = types.nullOr (types.listOf shortcutType);
        default = null;
      };
    };
  };

  config = let
    options = {
      inherit (cfg) theme hide;

      disable_move = cfg.disableMove;
      change_to_vcs_root = cfg.changeToVcsRoot;

      config = {
        inherit (cfg) header footer center project mru shortcut packages week_header;
        disable_move = cfg.disableMove;
      };

      preview = {
        inherit (cfg.preview) command file height width;
      };
    };

    filterNullOrEmptyAttrs = attrs:
      filterAttrs
      (
        _: v:
          v
          == null
          || v == {}
          || (builtins.isAttrs v && (filterNullOrEmptyAttrs v != {}))
      )
      attrs;

    # filteredOptions = filterAttrs (_: v: v != null) options;
    filteredOptions = filterNullOrEmptyAttrs options;
  in
    mkIf cfg.enable {
      extraPlugins = [cfg.package];
      extraConfigLua = ''
        require("dashboard").setup(${helpers.toLuaObject filteredOptions})
      '';
    };
}
