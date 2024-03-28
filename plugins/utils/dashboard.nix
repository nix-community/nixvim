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

      theme =
        helpers.defaultNullOpts.mkNullable
        (with types; either (enum ["hyper"]) (enum ["doom"]))
        "hyper"
        "The dashboard's theme.";

      disableMove =
        helpers.defaultNullOpts.mkBool
        true
        "Whether to disable the move keys";

      shortcutType =
        helpers.defaultNullOpts.mkNullable
        (with types; either (enum ["letter"]) (enum ["number"]))
        "letter"
        "The shortcut type.";

      changeVCSRoot =
        helpers.defaultNullOpts.mkBool
        false
        "Change the root of VCS for the `hyper` theme's MRU module.";

      header =
        helpers.defaultNullOpts.mkListOf
        types.str
        "null"
        "The header's text.";

      weekHeader = mkOption {
        description = "Week header options";
        type = types.submodule {
          options = {
            enable =
              helpers.defaultNullOpts.mkBool
              false
              "Whether to enable the week header.";

            concat =
              helpers.defaultNullOpts.mkNullable
              types.str
              "null"
              "Text to be added after the time string line.";

            append =
              helpers.defaultNullOpts.mkListOf
              types.str
              "null"
              "List of text to be appended after the time string line, since the `header` is filled by `weekHeader` this allows you to create ASCII art right below it.";
          };
        };
        default = {};
        example = {
          enable = true;
          concat = "Some text to be going after the clock.";
          append = [
            "⠤⠤⠤⠤⠤⠤⢤⣄⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠙⠒⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠤⠤⠶⠶⠶⠦⠤⠤⠤⠤⠤⢤⣤⣀⣀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⢀⠄⢂⣠⣭⣭⣕⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠤⠀⠀⠀⠤⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉⠉⠉⠉"
            "⠀⠀⢀⠜⣳⣾⡿⠛⣿⣿⣿⣦⡠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⣤⣤⣤⣤⣤⣤⣤⣤⣤⣍⣀⣦⠦⠄⣀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠠⣄⣽⣿⠋⠀⡰⢿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⡿⠛⠛⡿⠿⣿⣿⣿⣿⣿⣿⣷⣶⣿⣁⣂⣤⡄⠀⠀⠀⠀⠀⠀"
            "⢳⣶⣼⣿⠃⠀⢀⠧⠤⢜⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⠟⠁⠀⠀⠀⡇⠀⣀⡈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡀⠁⠐⠀⣀⠀⠀"
            "⠀⠙⠻⣿⠀⠀⠀⠀⠀⠀⢹⣿⣿⡝⢿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⡿⠋⠀⠀⠀⠀⠠⠃⠁⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣿⡿⠋⠀⠀"
            "⠀⠀⠀⠙⡄⠀⠀⠀⠀⠀⢸⣿⣿⡃⢼⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⡏⠉⠉⠻⣿⡿⠋⠀⠀⠀⠀"
            "⠀⠀⠀⠀⢰⠀⠀⠰⡒⠊⠻⠿⠋⠐⡼⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⠀⠀⠀⠀⣿⠇⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⠸⣇⡀⠀⠑⢄⠀⠀⠀⡠⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢖⠠⠤⠤⠔⠙⠻⠿⠋⠱⡑⢄⠀⢠⠟⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⠀⠀⠈⠉⠒⠒⠻⠶⠛⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⡄⠀⠀⠀⠀⠀⠀⠀⠀⠡⢀⡵⠃⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠦⣀⠀⠀⠀⠀⠀⢀⣤⡟⠉⠀⠀⠀⠀⠀⠀⠀⠀"
            "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠙⠛⠓⠒⠲⠿⢍⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
          ];
        };
      };

      footer =
        helpers.defaultNullOpts.mkListOf
        types.str
        "null"
        "Dashboard's footer text";

      shortcut = mkOption {
        description = "Shortcut section, only available for the `hyper` theme";
        type = with types;
          nullOr (listOf (submodule {
            options = {
              desc =
                helpers.defaultNullOpts.mkNullable
                types.str
                "null"
                "The shortcut's description";

              group =
                helpers.defaultNullOpts.mkNullable
                types.str
                "null"
                "The highlight group of the action";

              action =
                helpers.defaultNullOpts.mkNullable
                types.str
                "null"
                "The action to be taken";
            };
          }));
        default = null;
        example = [
          {
            desc = "Find files";
            group = "EndOfBuffer";
            action = "Telescope find_files";
          }
        ];
      };

      showPackages =
        helpers.defaultNullOpts.mkBool
        false
        "Whether to hide what packages have looaded. Only available in the 'hyper' theme";

      project = mkOption {
        description = "Project showcase options. Only available in the 'hyper' theme";
        type = with types;
          nullOr (submodule {
            options = {
              enable =
                helpers.defaultNullOpts.mkNullable
                types.bool
                "null"
                "Whether to enable the showcase of the project list";

              limit =
                helpers.defaultNullOpts.mkNullable
                types.int
                "null"
                "The limit of projects to be showcased";

              icon =
                helpers.defaultNullOpts.mkNullable
                types.str
                "null"
                "The icon of the project section";

              label =
                helpers.defaultNullOpts.mkNullable
                types.str
                "null"
                "The label of the project section";

              action =
                helpers.defaultNullOpts.mkNullable
                types.str
                "null"
                "The action to be ran when selecting a project, this can be a function";
            };
          });
        default = null;
        example = {
          enable = true;
          limit = 10;
          icon = "»";
          label = "Find projects' files";
          action = "Telescope find_files cwd=";
        };
      };

      mru = mkOption {
        description = "Configuration for the 'Most Recently Files' module.";
        type = with types;
          nullOr (submodule {
            options = {
              limit =
                helpers.defaultNullOpts.mkNullable
                types.int
                "null"
                "The limit of recently opened files to be shown";

              icon =
                helpers.defaultNullOpts.mkNullable
                types.str
                "null"
                "The icon of the module's section";

              label =
                helpers.defaultNullOpts.mkNullable
                types.str
                "null"
                "The label of the module's section";

              cwd_only =
                helpers.defaultNullOpts.mkNullable
                types.bool
                "null"
                "Whether to only change the directory when selecting a file";
            };
          });
        default = null;
        example = {
          limit = 10;
          icon = "»";
          label = "Most recently opened files";
          cwd_only = true;
        };
      };

      center = mkOption {
        description = "Center section";
        type = with types;
          nullOr (listOf (submodule {
            options = {
              icon =
                helpers.defaultNullOpts.mkNullable
                types.str
                "null"
                "Item's icon";

              icon_hl =
                helpers.defaultNullOpts.mkNullable
                types.str
                "null"
                "Icon's highlight group";

              desc =
                helpers.defaultNullOpts.mkNullable
                types.str
                "null"
                "Item's description";

              desc_hl =
                helpers.defaultNullOpts.mkNullable
                types.str
                "null"
                "Description's highlight group";

              key =
                helpers.defaultNullOpts.mkNullable
                types.str
                "null"
                "Item's shortcut";

              key_hl =
                helpers.defaultNullOpts.mkNullable
                types.str
                "null"
                "Shortcut's highlight group";

              key_format =
                helpers.defaultNullOpts.mkNullable
                types.str
                "null"
                "Shortcut's text format, %s will be replaced with the value of `key`";

              action =
                helpers.defaultNullOpts.mkNullable
                types.str
                "null"
                "Item's action";
            };
          }));
        default = null;
        example = [
          {
            icon = "Ω";
            icon_hl = "Directory";
            desc = "Find files";
            desc_hl = "ModeMsg";
            key = "<leader>f";
            key_hl = "CurSearch";
            key_format = "{ %s }";
            action = "Telescope find_files";
          }
        ];
      };

      preview = mkOption {
        description = "Preview options";
        type = types.submodule {
          options = {
            command =
              helpers.defaultNullOpts.mkStr
              ""
              "Command to print file contents";

            file =
              helpers.defaultNullOpts.mkNullable
              types.str
              "null"
              "Path to preview file";

            height =
              helpers.defaultNullOpts.mkInt
              0
              "The height of the preview file";

            width =
              helpers.defaultNullOpts.mkInt
              0
              "The width of the preview file";
          };
        };
        default = {};
      };

      hideStatusline =
        helpers.defaultNullOpts.mkBool
        true
        "Whether to hide statusline in Dashboard buffer";

      hideTabline =
        helpers.defaultNullOpts.mkBool
        true
        "Whether to hide tabline in Dashboard buffer";

      hideWinbar =
        helpers.defaultNullOpts.mkBool
        false
        "Whether to hide winbar in Dashboard buffer";
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
