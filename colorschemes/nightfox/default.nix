{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts mkNullOrOption literalLua;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "nightfox";
  isColorscheme = true;
  package = "nightfox-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  colorscheme = null;
  extraOptions = {
    flavor = lib.mkOption {
      type = types.enum [
        "carbonfox"
        "dawnfox"
        "dayfox"
        "duskfox"
        "nightfox"
        "nordfox"
        "terafox"
      ];
      example = "dayfox";
      default = "nightfox";
      description = "Which palette/flavor to use as the colorscheme.";
    };
  };
  extraConfig = cfg: { colorscheme = lib.mkDefault cfg.flavor; };

  settingsOptions = {
    options = {
      compile_path = defaultNullOpts.mkStr (literalLua "vim.fn.stdpath('cache') .. '/nightfox'") ''
        The output directory path where the compiled results will be written to.
      '';

      compile_file_suffix = defaultNullOpts.mkStr "_compiled" ''
        The string appended to the compiled file.
        Each `style` outputs to its own file.
        These files will append the suffix to the end of the file.
      '';

      transparent = defaultNullOpts.mkBool false ''
        A boolean value that if set will disable setting the background of `Normal`, `NormalNC` and
        other highlight groups.
        This lets you use the colors of the colorscheme but use the background of your terminal.
      '';

      terminal_colors = defaultNullOpts.mkBool true ''
        A boolean value that if set will define the terminal colors for the builtin `terminal`
        (`vim.g.terminal_color_*`).
      '';

      dim_inactive = defaultNullOpts.mkBool false ''
        A boolean value that if set will set the background of Non current windows to be darker.
        See `:h hl-NormalNC`.
      '';

      module_default = defaultNullOpts.mkBool true ''
        The default value of a module that has not been overridden in the modules table.
      '';

      styles = defaultNullOpts.mkAttrsOf' {
        type = types.str;
        description = ''
          A table that contains a list of syntax components and their corresponding style.
          These styles can be any combination of `|highlight-args|`.

          The list of syntax components are:
            - comments
            - conditionals
            - constants
            - functions
            - keywords
            - numbers
            - operators
            - preprocs
            - strings
            - types
            - variables
        '';
        example = {
          comments = "italic";
          functions = "italic,bold";
        };
        pluginDefault = {
          comments = "NONE";
          conditionals = "NONE";
          constants = "NONE";
          functions = "NONE";
          keywords = "NONE";
          numbers = "NONE";
          operators = "NONE";
          preprocs = "NONE";
          strings = "NONE";
          types = "NONE";
          variables = "NONE";
        };
      };

      inverse =
        defaultNullOpts.mkAttrsOf types.bool
          {
            match_paren = false;
            visual = false;
            search = false;
          }
          ''
            A table that contains a list of highlight types.
            If a highlight type is enabled it will inverse the foreground and background colors
            instead of applying the normal highlight group.
            Thees highlight types are: `match_paren`, `visual`, `search`.

            For an example if search is enabled instead of highlighting a search term with the default
            search color it will inverse the foureground and background colors.
          '';

      colorblind = {
        enable = defaultNullOpts.mkBool false ''
          Whether to enable nightfox’s _color vision deficiency_ (cdv) mode.
        '';

        simulate_only = defaultNullOpts.mkBool false ''
          Only show simulated colorblind colors and not diff shifted.
        '';

        severity =
          lib.mapAttrs
            (
              name: color:
              defaultNullOpts.mkProportion 0 ''
                Severity [0, 1] for ${name} (${color}).
              ''
            )
            {
              protan = "red";
              deutan = "green";
              tritan = "blue";
            };
      };

      modules =
        defaultNullOpts.mkAttrsOf types.anything
          {
            coc = {
              background = true;
            };
            diagnostic = {
              enable = true;
              background = true;
            };
            native_lsp = {
              enable = true;
              background = true;
            };
            treesitter = true;
            lsp_semantic_tokens = true;
            leap = {
              background = true;
            };
          }
          ''
            `modules` store configuration information for various plugins and other neovim modules.
            A module can either be a boolean or a table that contains additional configuration for
            that module.
            If the value is a table it also has a field called `enable` that will tell nightfox to
            load it.
            See `|nightfox-modules|` for more information.

            By default modules will be enabled.
            To change this behaviour change `options.module_default` to `false`.
          '';
    };

    palettes =
      mkNullOrOption
        (
          with types;
          attrsOf
            # A theme (or `all`)
            (
              attrsOf
                # A color
                (either str (attrsOf str))
            )
        )
        ''
          A `palette` is the base color definitions of a style.
          Each style defines its own palette to be used by the other components.
          A palette defines base colors, as well as foreground and background shades.
          Along with the foreground and background colors a palette also defines other colors such
          as selection and comment colors.

          The base colors are |nightfox-shade| objects that define a `base`, `bright`, and `dim`
          color.
          These base colors are: `black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`,
          `white`, `orange`, `pink`.

          Example:
          ```nix
            {
              all = {
                red = "#ff0000";
              };
              nightfox = {
                red = "#c94f6d";
              };
              dayfox = {
                blue = {
                  base = "#4d688e";
                  bright = "#4e75aa";
                  dim = "#485e7d";
                };
              };
              nordfox = {
                bg1 = "#2e3440";
                sel0 = "#3e4a5b";
                sel1 = "#4f6074";
                comment = "#60728a";
              };
            }
          ```
        '';

    specs =
      mkNullOrOption
        (
          with types;
          attrsOf
            # A theme (or `all`)
            (
              attrsOf
                # `inactive`, `syntax`, `git`, ...
                (either str (attrsOf str))
            )
        )
        ''
          Spec's (specifications) are a mapping of palettes to logical groups that will be used by
          the groups.
          Some examples of the groups that specs map would be:
            - syntax groups (functions, types, keywords, ...)
            - diagnostic groups (error, warning, info, hints)
            - git groups (add, removed, changed)

          You can override these just like palettes.

          Example:
          ```nix
            {
              all = {
                syntax = {
                  keyword = "magenta";
                  conditional = "magenta.bright";
                  number = "orange.dim";
                };
                git = {
                  changed = "#f4a261";
                };
              };
              nightfox = {
                syntax = {
                  operator = "orange";
                };
              };
            }
          ```
        '';

    groups =
      mkNullOrOption
        (
          with types;
          attrsOf
            # A theme (or `all`)
            (
              attrsOf
                # `Whitespace`, `IncSearch`, ...
                (attrsOf str)
            )
        )
        ''
          Groups are the highlight group definitions.
          The keys of this table are the name of the highlight groups that will be overridden.
          The value is a table with the following values:
            - fg, bg, style, sp, link,

          Just like `spec` groups support templates.
          This time the template is based on a spec object.

          Example:
          ```nix
            {
              all = {
                Whitespace.link = "Comment";
                IncSearch.bg = "palette.cyan";
              },
              nightfox.PmenuSel = {
                bg = "#73daca";
                fg = "bg0";
              };
            }
          ```
        '';
  };

  settingsExample = {
    options = {
      transparent = true;
      terminal_colors = true;
      styles = {
        comments = "italic";
        functions = "italic,bold";
      };
      inverse = {
        match_paren = false;
        visual = false;
        search = true;
      };
      colorblind = {
        enable = true;
        severity = {
          protan = 0.3;
          deutan = 0.6;
        };
      };
      modules = {
        coc.background = false;
        diagnostic = {
          enable = true;
          background = false;
        };
      };
    };
    palettes.duskfox = {
      bg1 = "#000000";
      bg0 = "#1d1d2b";
      bg3 = "#121820";
      sel0 = "#131b24";
    };
    specs = {
      all.inactive = "bg0";
      duskfox.inactive = "#090909";
    };
    groups.all.NormalNC = {
      fg = "fg1";
      bg = "inactive";
    };
  };
}
