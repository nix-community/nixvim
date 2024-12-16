{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "kanagawa";
  isColorscheme = true;
  packPathName = "kanagawa.nvim";
  package = "kanagawa-nvim";

  description = ''
    You can select the theme in two ways:
    - Set `colorschemes.kanagawa.settings.theme` AND explicitly unset `vim.o.background` (i.e. `options.background = ""`).
    - Set `colorschemes.kanagawa.settings.background` (the active theme will depend on the value of `vim.o.background`).
  '';

  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO introduced 2024-03-15: remove 2024-05-15
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    "compile"
    "undercurl"
    "commentStyle"
    "functionStyle"
    "keywordStyle"
    "statementStyle"
    "typeStyle"
    "transparent"
    "dimInactive"
    "terminalColors"
    [
      "colors"
      "palette"
    ]
    [
      "colors"
      "theme"
    ]
    "theme"
    [
      "background"
      "dark"
    ]
    [
      "background"
      "light"
    ]

  ];
  imports = [
    (lib.mkRemovedOptionModule
      [
        "colorschemes"
        "kanagawa"
        "overrides"
      ]
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
    compile = defaultNullOpts.mkBool false ''
      Enable compiling the colorscheme.
    '';

    undercurl = defaultNullOpts.mkBool true ''
      Enable undercurls.
    '';

    commentStyle = defaultNullOpts.mkAttrsOf types.anything { italic = true; } ''
      Highlight options for comments.
    '';

    functionStyle = defaultNullOpts.mkAttrsOf types.anything { } ''
      Highlight options for functions.
    '';

    keywordStyle = defaultNullOpts.mkAttrsOf types.anything { italic = true; } ''
      Highlight options for keywords.
    '';

    statementStyle = defaultNullOpts.mkAttrsOf types.anything { bold = true; } ''
      Highlight options for statements.
    '';

    typeStyle = defaultNullOpts.mkAttrsOf types.anything { } ''
      Highlight options for types.
    '';

    transparent = defaultNullOpts.mkBool false ''
      Whether to set a background color.
    '';

    dimInactive = defaultNullOpts.mkBool false ''
      Whether dim inactive window `:h hl-NormalNC`.
    '';

    terminalColors = defaultNullOpts.mkBool true ''
      If true, defines `vim.g.terminal_color_{0,17}`.
    '';

    colors = {
      theme =
        defaultNullOpts.mkAttrsOf types.attrs
          {
            wave = { };
            lotus = { };
            dragon = { };
            all = { };
          }
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

      palette = defaultNullOpts.mkAttrsOf types.str { } ''
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
      defaultNullOpts.mkLuaFn
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

    theme = defaultNullOpts.mkStr "wave" ''
      The theme to load when background is not set.
    '';

    background = {
      light = defaultNullOpts.mkStr "lotus" ''
        The theme to use when `vim.o.background = "light"`.
      '';

      dark = defaultNullOpts.mkStr "wave" ''
        The theme to use when `vim.o.background = "dark"`.
      '';
    };
  };

  settingsExample = {
    compile = false;
    undercurl = true;
    commentStyle.italic = true;
    functionStyle = { };
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
