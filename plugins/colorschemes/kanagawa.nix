{
  lib,
  helpers,
  pkgs,
  config,
  ...
}:
with lib;
  helpers.neovim-plugin.mkNeovimPlugin config {
    name = "kanagawa";
    isColorscheme = true;
    originalName = "kanagawa.nvim";
    defaultPackage = pkgs.vimPlugins.kanagawa-nvim;

    description = ''
      You can select the theme in two ways:
      - Set `colorschemes.kanagawa.settings.theme` AND explicitly unset `vim.o.background` (i.e. `options.background = ""`).
      - Set `colorschemes.kanagawa.settings.background` (the active theme will depend on the value of `vim.o.background`).
    '';

    maintainers = [maintainers.GaetanLepage];

    # TODO introduced 2024-03-15: remove 2024-05-15
    deprecateExtraOptions = true;
    imports = let
      basePluginPath = ["colorschemes" "kanagawa"];
    in
      (
        map
        (
          optionPath:
            mkRenamedOptionModule
            (basePluginPath ++ optionPath)
            (basePluginPath ++ ["settings"] ++ optionPath)
        )
        [
          ["compile"]
          ["undercurl"]
          ["commentStyle"]
          ["functionStyle"]
          ["keywordStyle"]
          ["statementStyle"]
          ["typeStyle"]
          ["transparent"]
          ["dimInactive"]
          ["terminalColors"]
          ["colors" "palette"]
          ["colors" "theme"]
          ["theme"]
          ["background" "dark"]
          ["background" "light"]
        ]
      )
      ++ [
        (
          mkRemovedOptionModule
          (basePluginPath ++ ["overrides"])
          ''
            Use `colorschemes.kanagawa.settings.overrides` but you now have to add the full function definition:
            ```
              function(colors)
                ...
              end
            ```
          ''
        )
      ];

    settingsOptions = {
      compile = helpers.defaultNullOpts.mkBool false ''
        Enable compiling the colorscheme.
      '';

      undercurl = helpers.defaultNullOpts.mkBool true ''
        Enable undercurls.
      '';

      commentStyle = helpers.defaultNullOpts.mkAttrsOf types.anything "{italic = true;}" ''
        Highlight options for comments.
      '';

      functionStyle = helpers.defaultNullOpts.mkAttrsOf types.anything "{}" ''
        Highlight options for functions.
      '';

      keywordStyle = helpers.defaultNullOpts.mkAttrsOf types.anything "{italic = true;}" ''
        Highlight options for keywords.
      '';

      statementStyle = helpers.defaultNullOpts.mkAttrsOf types.anything "{bold = true;}" ''
        Highlight options for statements.
      '';

      typeStyle = helpers.defaultNullOpts.mkAttrsOf types.anything "{}" ''
        Highlight options for types.
      '';

      transparent = helpers.defaultNullOpts.mkBool false ''
        Whether to set a background color.
      '';

      dimInactive = helpers.defaultNullOpts.mkBool false ''
        Whether dim inactive window `:h hl-NormalNC`.
      '';

      terminalColors = helpers.defaultNullOpts.mkBool true ''
        If true, defines `vim.g.terminal_color_{0,17}`.
      '';

      colors = {
        theme =
          helpers.defaultNullOpts.mkAttrsOf types.attrs
          ''
            {
              wave = {};
              lotus = {};
              dragon = {};
              all = {};
            }
          ''
          ''
            Change specific usages for a certain theme, or for all of them

            Example:
            ```nix
              {
                wave = {
                  ui = {
                      float = {
                          bg = "none";
                      };
                  };
                };
                dragon = {
                    syn = {
                        parameter = "yellow";
                    };
                };
                all = {
                    ui = {
                        bg_gutter = "none";
                    };
                };
              }
            ```
          '';

        palette = helpers.defaultNullOpts.mkAttrsOf types.str "{}" ''
          Change all usages of these colors.

          Example:
          ```nix
            {
              sumiInk0 = "#000000";
              fujiWhite = "#FFFFFF";
            }
          ```
        '';
      };

      overrides =
        helpers.defaultNullOpts.mkLuaFn
        ''
          function(colors)
            return {}
          end
        ''
        ''
          The body of a function that add/modify hihlights.
          It takes as input a `colors` argument which is a table of this form:
          ```
            colors = {
              palette = {
                foo = "#RRGGBB",
                bar = "#RRGGBB"
              },
              theme = {
                foo = "#RRGGBB",
                bar = "#RRGGBB"
              }
            }
          ```
          It should return a table of highlights.

          ```
            function(colors)
              CONTENT_OF_OVERRIDE_OPTION
            end
          ```
        '';

      theme = helpers.defaultNullOpts.mkStr "wave" ''
        The theme to load when background is not set.
      '';

      background = {
        light = helpers.defaultNullOpts.mkStr "lotus" ''
          The theme to use when `vim.o.background = "light"`.
        '';

        dark = helpers.defaultNullOpts.mkStr "wave" ''
          The theme to use when `vim.o.background = "dark"`.
        '';
      };
    };

    settingsExample = {
      compile = false;
      undercurl = true;
      commentStyle.italic = true;
      functionStyle = {};
      transparent = false;
      dimInactive = false;
      terminalColors = true;
      colors = {
        theme = {
          wave.ui.float.bg = "none";
          dragon.syn.parameter = "yellow";
          all.ui.bg_gutter = "none";
        };
        palette = {
          sumiInk0 = "#000000";
          fujiWhite = "#FFFFFF";
        };
      };
      overrides = "function(colors) return {} end";
      theme = "wave";
    };
  }
