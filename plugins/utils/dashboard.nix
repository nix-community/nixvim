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

      disableMove = mkOption {
        description = "Whether to disable the move keys";
        type = types.bool;
        default = true;
      };

      shortcutType = mkOption {
        description = "Shortcut type";
        type = with types; nullOr (oneOf [(enum ["letter"]) (enum ["number"])]);
        default = null;
      };

      changeVCSRoot = mkOption {
        description = "Change to the root of VCS for hyper mru";
        type = types.nullOr types.bool;
        default = false;
      };

      header = mkOption {
        description = "Header text";
        type = types.nullOr (types.listOf types.str);
        default = null;
      };

      weekHeader = mkOption {
        description = "Week header options";
        type = types.nullOr (types.submodule {
          options = {
            enable = mkOption {
              description = "Whether to enable the week header";
              type = types.nullOr types.bool;
              default = null;
            };

            concat = mkOption {
              description = "Text to be added after the time string line";
              type = types.nullOr types.str;
              default = null;
            };

            append = mkOption {
              description = "Text to be 'table' appended after the time string line";
              type = types.nullOr types.str;
              default = null;
            };
          };
        });
        default = null;
      };

      footer = mkOption {
        description = "Footer text";
        type = types.nullOr (types.listOf types.str);
        default = null;
      };

      shortcut = mkOption {
        description = "Shortcut section, only available for the `hyper` theme";
        type = types.nullOr (types.listOf (types.submodule {
          options = {
            desc = mkOption {
              description = "The description of the action";
              type = types.nullOr types.str;
              default = null;
            };

            group = mkOption {
              description = "The highlight group of the action";
              type = types.nullOr types.str;
              default = null;
            };

            action = mkOption {
              description = "The action to be taken";
              type = types.nullOr types.str;
              default = null;
            };
          };
        }));
        default = null;
      };

      showPackages = mkOption {
        description = "Whether to hide what packages have looaded. Only available in the 'hyper' theme";
        type = types.bool;
        default = false;
      };

      project = mkOption {
        description = "Project showcase options. Only available in the 'hyper' theme";
        type = types.nullOr (types.submodule {
          options = {
            enable = mkOption {
              description = "Whether to enable the showcase of the project list";
              type = types.nullOr types.bool;
              default = null;
            };

            limit = mkOption {
              description = "The limit of projects to be showcased";
              type = types.nullOr types.int;
              default = null;
            };

            icon = mkOption {
              description = "The icon of the project section";
              type = types.nullOr types.str;
              default = null;
            };

            label = mkOption {
              description = "The label of the project section";
              type = types.nullOr types.str;
              default = null;
            };

            action = mkOption {
              description = "The action to be ran when selecting a project, this can be a function";
              type = types.nullOr types.str;
              default = null;
            };
          };
        });
        default = null;
      };

      mru = mkOption {
        description = "MRU section";
        type = types.nullOr (types.submodule {
          options = {
            limit = mkOption {
              description = "The limit of recently opened projects to be shown";
              type = types.nullOr types.int;
              default = null;
            };

            icon = mkOption {
              description = "The icon of the MRU section";
              type = types.nullOr types.str;
              default = null;
            };

            label = mkOption {
              description = "The label of the MRU section";
              type = types.nullOr types.str;
              default = null;
            };

            cwd_only = mkOption {
              description = "Whether to cwd only";
              type = types.nullOr types.bool;
              default = null;
            };
          };
        });
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

            icon_hl = mkOption {
              description = "Icon's highlight group";
              type = types.nullOr types.str;
              default = null;
            };

            desc = mkOption {
              description = "Item description";
              type = types.str;
            };

            desc_hl = mkOption {
              description = "Description's highlight group";
              type = types.nullOr types.str;
              default = null;
            };

            key = mkOption {
              description = "Item shortcut";
              type = types.nullOr types.str;
              default = null;
            };
            key_hl = mkOption {
              description = "Shortcut's highlight group";
              type = types.nullOr types.str;
              default = null;
            };

            key_format = mkOption {
              description = "Shortcut's text format, %s will be replaced with the value of `key`";
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
      inherit (cfg) theme;

      change_to_vcs_root = cfg.changeVCSRoot;
      disable_move = cfg.disableMove;
      shortcut_type = cfg.shortcutType;

      config = {
        inherit (cfg) footer header;
        week_header = cfg.weekHeader;

        # According to the README, it's located both outside and inside config
        disable_move = cfg.disableMove;

        # Only available in "hyper" theme
        inherit (cfg) project shortcut;
        packages.enable = cfg.showPackages;

        # Only available in "doom" theme
        inherit (cfg) center;
      };

      hide = {
        statusline = cfg.hideStatusline;
        tabline = cfg.hideTabline;
        winbar = cfg.hideWinbar;
      };

      preview = {
        inherit (cfg.preview) command;

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
