{
  lib,
  helpers,
  ...
}:
with lib;
lib.nixvim.plugins.mkNeovimPlugin {
  name = "dashboard";
  packPathName = "dashboard-nvim";
  package = "dashboard-nvim";
  description = "Fancy and Blazing Fast start screen plugin for Neovim.";

  maintainers = [ maintainers.MattSturgeon ];

  # TODO introduced 2024-05-30: remove 2024-09-01
  optionsRenamedToSettings = [
    {
      old = "header";
      new = [
        "config"
        "header"
      ];
    }
    {
      old = "footer";
      new = [
        "config"
        "footer"
      ];
    }
    {
      old = "center";
      new = [
        "config"
        "shortcut"
      ];
    }
    {
      old = "hideStatusline";
      new = [
        "hide"
        "statusline"
      ];
    }
    {
      old = "hideTabline";
      new = [
        "hide"
        "tabline"
      ];
    }
    [
      "preview"
      "command"
    ]
    {
      old = [
        "preview"
        "file"
      ];
      new = [
        "preview"
        "file_path"
      ];
    }
    {
      old = [
        "preview"
        "height"
      ];
      new = [
        "preview"
        "file_height"
      ];
    }
    {
      old = [
        "preview"
        "width"
      ];
      new = [
        "preview"
        "file_width"
      ];
    }
  ];
  imports = [
    (mkRemovedOptionModule [
      "plugins"
      "dashboard"
      "sessionDirectory"
    ] "This plugin no longer has session support.")
  ];

  settingsExample = {
    theme = "hyper";
    change_to_vcs_root = true;

    config = {
      week_header.enable = true;
      project.enable = false;
      mru.limit = 20;

      header = [
        "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
        "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
        "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
        "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
        "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
        "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
      ];

      shortcut = [
        {
          icon = " ";
          icon_hl = "@variable";
          desc = "Files";
          group = "Label";
          action.__raw = "function(path) vim.cmd('Telescope find_files') end";
          key = "f";
        }
        {
          desc = " Apps";
          group = "DiagnosticHint";
          action = "Telescope app";
          key = "a";
        }
        {
          desc = " dotfiles";
          group = "Number";
          action = "Telescope dotfiles";
          key = "d";
        }
      ];

      footer = [ "Made with ❤️" ];
    };
  };

  settingsOptions =
    let
      requiresTheme = theme: ''
        **Note**: This option is only compatible with the "${theme}" theme.
      '';

      # Make an "action" submodule type, as used by `settings.config.shortcut` and `settings.config.center`
      mkActionType =
        extraOptions:
        types.submodule {
          freeformType = with types; attrsOf anything;

          options = {
            icon = helpers.defaultNullOpts.mkStr "" ''
              The icon to display with this action.
            '';

            icon_hl = helpers.defaultNullOpts.mkStr "DashboardIcon" ''
              The highlight group for the icon.
            '';

            desc = helpers.defaultNullOpts.mkStr "" ''
              The action's description, shown next to the icon.
            '';

            desc_hl = helpers.defaultNullOpts.mkStr "DashboardDesc" ''
              The highlight group to use for the description.
            '';

            key = helpers.defaultNullOpts.mkStr "" ''
              Shortcut key available in the dashboard buffer.

              **Note**: this will not create an actual keymap.
            '';

            key_hl = helpers.defaultNullOpts.mkStr "DashboardKey" ''
              The highlight group to use for the key.
            '';

            action = helpers.defaultNullOpts.mkStr "" ''
              Action done when you press key. Can be a command or a function.

              To use a lua function, pass a raw type instead of a string, e.g:

              ```nix
                action.__raw = "function(path) vim.cmd('Telescope find_files cwd=' .. path) end";
              ```

              Is equivialent to:

              ```nix
                action = "Telescope find_files cwd=";
              ```
            '';
          }
          // extraOptions;
        };
    in
    {
      theme =
        helpers.defaultNullOpts.mkEnumFirstDefault
          [
            "hyper"
            "doom"
          ]
          ''
            Dashboard comes with two themes, that each have their own distinct config options.

            - "hyper" includes a header, custom shortcuts, recent projects, recent files, and a footer.
            - "doom" is simpler, consisting of a header, center, and footer.

            Some options have a _note_ stating which theme they relate to.
          '';

      shortcut_type =
        helpers.defaultNullOpts.mkEnumFirstDefault
          [
            "letter"
            "number"
          ]
          ''
            The shortcut type.
          '';

      change_to_vcs_root = helpers.defaultNullOpts.mkBool false ''
        When opening a file in the "hyper" theme's "recent files" list (`mru`), vim will change to the root of vcs.
      '';

      config = {
        # TODO double check if this affects "doom" or not
        disable_move = helpers.defaultNullOpts.mkBool false ''
          Disable movement keymaps in the dashboard buffer.

          Specifically, the following keymaps are disabled:

          `w`, `f`, `b`, `h`, `j`, `k`, `l`, `<Up>`, `<Down>`, `<Left>`, `<Right>`
        '';

        packages.enable = helpers.defaultNullOpts.mkBool true ''
          Show how many vim plugins are loaded.

          ${requiresTheme "hyper"}
        '';

        week_header = {
          enable = helpers.defaultNullOpts.mkBool false ''
            Whether to use a header based on the current day of the week,
            instead of the default "DASHBOARD" header.

            A subheading showing the current time is also displayed.
          '';

          concat = helpers.defaultNullOpts.mkStr "" ''
            Additional text to append at the end of the time line.
          '';

          append = helpers.defaultNullOpts.mkListOf types.str [ ] ''
            Additional header lines to append after the the time line.
          '';
        };

        header =
          helpers.defaultNullOpts.mkNullableWithRaw (with types; either str (listOf (maybeRaw str)))
            [
              ""
              " ██████╗  █████╗ ███████╗██╗  ██╗██████╗  ██████╗  █████╗ ██████╗ ██████╗  "
              " ██╔══██╗██╔══██╗██╔════╝██║  ██║██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██╔══██╗ "
              " ██║  ██║███████║███████╗███████║██████╔╝██║   ██║███████║██████╔╝██║  ██║ "
              " ██║  ██║██╔══██║╚════██║██╔══██║██╔══██╗██║   ██║██╔══██║██╔══██╗██║  ██║ "
              " ██████╔╝██║  ██║███████║██║  ██║██████╔╝╚██████╔╝██║  ██║██║  ██║██████╔╝ "
              " ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝  "
              ""
            ]
            ''
              The header text, displayed at the top of the buffer.
            '';

        footer = helpers.defaultNullOpts.mkListOf types.str [ ] ''
          The footer text, displayed at the bottom of the buffer.
        '';

        # TODO: Once #1618 is fixed, we can switch to `defaultNullOpts.mkAttrs'`,
        shortcut = helpers.mkNullOrOption' {
          description = ''
            Shortcut actions to be added to the "hyper" theme.

            ${requiresTheme "hyper"}
          '';

          example = [
            {
              icon = " ";
              icon_hl = "@variable";
              desc = "Files";
              group = "Label";
              action.__raw = "function(path) vim.cmd('Telescope find_files') end";
              key = "f";
            }
            {
              desc = " Apps";
              group = "DiagnosticHint";
              action = "Telescope app";
              key = "a";
            }
            {
              desc = " dotfiles";
              group = "Number";
              action = "Telescope dotfiles";
              key = "d";
            }
          ];

          type = types.listOf (mkActionType {
            group = helpers.defaultNullOpts.mkStr "" ''
              Highlight group used with the "hyper" theme,
            '';
          });
        };

        # TODO: Once #1618 is fixed, we can switch to `defaultNullOpts.mkAttrs'`,
        center = helpers.mkNullOrOption' {
          description = ''
            Actions to be added to the center section of the "doom" theme.

            ${requiresTheme "doom"}
          '';

          example = [
            {
              icon = " ";
              icon_hl = "Title";
              desc = "Find File           ";
              desc_hl = "String";
              key = "b";
              keymap = "SPC f f";
              key_hl = "Number";
              key_format = " %s";
              action = "lua print(2)";
            }
            {
              icon = " ";
              desc = "Find Dotfiles";
              key = "f";
              keymap = "SPC f d";
              key_format = " %s";
              action.__raw = "function() print(3) end";
            }
          ];

          type = types.listOf (mkActionType {
            # TODO if `key_format` is _also_ applicable to hyper theme,
            # move the option to `mkActionList`.
            key_format = helpers.defaultNullOpts.mkStr "[%s]" ''
              Format string used when rendering the key.
              `%s` will be substituted with value of `key`.
            '';
          });
        };

        project =
          helpers.mkCompositeOption
            ''
              Options relating to the "hyper" theme's recent projects list.

              ${requiresTheme "hyper"}
            ''
            {
              enable = helpers.defaultNullOpts.mkBool true ''
                Whether to display the recent projects list.
              '';

              limit = helpers.defaultNullOpts.mkInt 8 ''
                The maximum number of projects to list.
              '';

              icon = helpers.defaultNullOpts.mkStr "󰏓 " ''
                Icon used in the section header.
              '';

              icon_hl = helpers.defaultNullOpts.mkStr "DashboardRecentProjectIcon" ''
                Highlight group used for the icon.
              '';

              label = helpers.defaultNullOpts.mkStr " Recent Projects:" ''
                Text used in the section header.
              '';

              action = helpers.defaultNullOpts.mkStr "Telescope find_files cwd=" ''
                When you press key or enter it will run this action
              '';
            };

        mru =
          helpers.mkCompositeOption
            ''
              Options relating to the "hyper" theme's recent files list.

              ${requiresTheme "hyper"}
            ''
            {
              enable = helpers.defaultNullOpts.mkBool true ''
                Whether to display the recent file list.
              '';

              limit = helpers.defaultNullOpts.mkInt 10 ''
                The maximum number of files to list.
              '';

              icon = helpers.defaultNullOpts.mkStr " " ''
                Icon used in the section header.
              '';

              icon_hl = helpers.defaultNullOpts.mkStr "DashboardMruIcon" ''
                Highlight group used for the icon.
              '';

              label = helpers.defaultNullOpts.mkStr " Most Recent Files:" ''
                Text used in the section header.
              '';

              cwd_only = helpers.defaultNullOpts.mkBool false ''
                Whether to only include files from the current working directory.
              '';
            };
      };

      hide = {
        statusline = helpers.defaultNullOpts.mkBool true ''
          Whether to hide the status line.
        '';

        tabline = helpers.defaultNullOpts.mkBool true ''
          Whether to hide the status line.
        '';
      };

      preview = {
        command = helpers.defaultNullOpts.mkStr "" ''
          Command to print file contents.
        '';

        file_path = helpers.defaultNullOpts.mkStr null ''
          Path to preview file.
        '';

        file_height = helpers.defaultNullOpts.mkInt 0 ''
          The height of the preview file.
        '';

        file_width = helpers.defaultNullOpts.mkInt 0 ''
          The width of the preview file.
        '';
      };
    };
}
