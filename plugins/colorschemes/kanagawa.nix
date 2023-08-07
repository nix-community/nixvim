{
  pkgs,
  config,
  lib,
  ...
} @ args:
with lib; let
  cfg = config.colorschemes.kanagawa;
  helpers = import ../helpers.nix args;
in {
  options = {
    colorschemes.kanagawa =
      helpers.extraOptionsOptions
      // {
        enable = mkEnableOption "kanagawa";

        package = helpers.mkPackageOption "kanagawa" pkgs.vimPlugins.kanagawa-nvim;

        compile = helpers.defaultNullOpts.mkBool false "Enable compiling the colorscheme.";

        undercurl = helpers.defaultNullOpts.mkBool true "Enable undercurls.";

        commentStyle =
          helpers.defaultNullOpts.mkNullable
          types.attrs
          "{italic = true;}"
          "Highlight options for comments.";

        functionStyle =
          helpers.defaultNullOpts.mkNullable
          types.attrs
          "{}"
          "Highlight options for functions.";

        keywordStyle =
          helpers.defaultNullOpts.mkNullable
          types.attrs
          "{italic = true;}"
          "Highlight options for keywords.";

        statementStyle =
          helpers.defaultNullOpts.mkNullable
          types.attrs
          "{bold = true;}"
          "Highlight options for statements.";

        typeStyle =
          helpers.defaultNullOpts.mkNullable
          types.attrs
          "{}"
          "Highlight options for types.";

        transparent = helpers.defaultNullOpts.mkBool false "Whether to set a background color.";

        dimInactive = helpers.defaultNullOpts.mkBool false ''
          Whether dim inactive window `:h hl-NormalNC`.
        '';

        terminalColors = helpers.defaultNullOpts.mkBool true ''
          If true, defines `vim.g.terminal_color_{0,17}`.
        '';

        colors = {
          theme =
            helpers.defaultNullOpts.mkNullable
            (with types; attrsOf attrs)
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

          palette = helpers.defaultNullOpts.mkNullable (with types; attrsOf str) "{}" ''
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
          helpers.defaultNullOpts.mkStr
          ''
            return {}
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
  };
  config = let
    setupOptions = with cfg;
      {
        inherit
          compile
          undercurl
          commentStyle
          functionStyle
          keywordStyle
          statementStyle
          typeStyle
          transparent
          dimInactive
          terminalColors
          ;
        colors = with colors; {
          inherit theme palette;
        };
        overrides =
          helpers.ifNonNull' overrides
          (helpers.mkRaw ''
            function(colors)
              ${overrides}
            end
          '');
        inherit theme;
        background = with background; {
          inherit light dark;
        };
      }
      // cfg.extraOptions;
  in
    mkIf cfg.enable {
      colorscheme = "kanagawa";

      extraPlugins = [cfg.package];

      extraConfigLuaPre = ''
        require("kanagawa").setup(${helpers.toLuaObject setupOptions})
      '';
    };
}
