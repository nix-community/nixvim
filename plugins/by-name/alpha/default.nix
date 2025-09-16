{ lib, ... }:
let
  inherit (lib) mkOption types;
  inherit (lib.nixvim)
    defaultNullOpts
    mkAssertions
    mkRaw
    nestedLiteralLua
    toLuaObject
    ;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "alpha";
  packPathName = "alpha-nvim";
  package = "alpha-nvim";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  callSetup = false;

  settingsOptions = {
    layout =
      let
        sectionType = types.submodule {
          freeformType = with types; attrsOf anything;
          options = {
            type = mkOption {
              type = types.enum [
                "button"
                "group"
                "padding"
                "text"
                "terminal"
              ];
              example = "button";
              description = ''
                The type of the section.
              '';
            };

            val = defaultNullOpts.mkNullableWithRaw' {
              type =
                with types;
                oneOf [
                  # button || text
                  (maybeRaw str)
                  # padding
                  int
                  (listOf (
                    either str # text (list of strings)
                      (attrsOf anything) # group
                  ))
                ];
              example = "Some text";
              description = ''
                The value for the section.
              '';
            };

            opts = mkOption {
              type = with types; attrsOf anything;
              default = { };
              description = ''
                Additional options for the section.
              '';
            };
          };
        };
      in
      defaultNullOpts.mkNullableWithRaw' {
        type = with types; either str (listOf sectionType);
        example = [
          {
            type = "padding";
            val = 2;
          }
          {
            type = "text";
            val = [
              "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
              "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
              "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
              "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
              "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
              "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
            ];
            opts = {
              position = "center";
              hl = "Type";
            };
          }
          {
            type = "padding";
            val = 2;
          }
          {
            type = "group";
            val = [
              {
                type = "button";
                val = "  New file";
                on_press.__raw = "function() vim.cmd[[ene]] end";
                opts.shortcut = "n";
              }
              {
                type = "button";
                val = " Quit Neovim";
                on_press.__raw = "function() vim.cmd[[qa]] end";
                opts.shortcut = "q";
              }
            ];
          }
          {
            type = "padding";
            val = 2;
          }
          {
            type = "text";
            val = "Inspiring quote here.";
            opts = {
              position = "center";
              hl = "Keyword";
            };
          }
        ];
        description = ''
          List of sections to layout for the dashboard
        '';
      };

    opts = defaultNullOpts.mkAttrsOf' {
      type = types.anything;
      description = ''
        Optional global options.
      '';
    };
  };

  settingsExample = {
    layout = [
      {
        type = "padding";
        val = 2;
      }
      {
        type = "text";
        val = [
          "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
          "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
          "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
          "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
          "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
          "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
        ];
        opts = {
          position = "center";
          hl = "Type";
        };
      }
      {
        type = "padding";
        val = 2;
      }
      {
        type = "group";
        val = [
          {
            type = "button";
            val = "  New file";
            on_press = nestedLiteralLua "function() vim.cmd[[ene]] end";
            opts.shortcut = "n";
          }
          {
            type = "button";
            val = " Quit Neovim";
            on_press = nestedLiteralLua "function() vim.cmd[[qa]] end";
            opts.shortcut = "q";
          }
        ];
      }
      {
        type = "padding";
        val = 2;
      }
      {
        type = "text";
        val = "Inspiring quote here.";
        opts = {
          position = "center";
          hl = "Keyword";
        };
      }
    ];
  };

  extraOptions = {
    theme = defaultNullOpts.mkStr' {
      description = ''
        The theme to use for the dashboard.
      '';
      example = "dashboard";
      apply =
        value: if builtins.isString value then mkRaw ''require("alpha.themes.${value}").config'' else value;
    };
  };

  optionsRenamedToSettings = [
    "opts"
    "layout"
  ];

  extraConfig =
    opts: cfg:
    let
      layoutDefined = cfg.settings.layout or null != null;
      themeDefined = cfg.theme != null;
    in
    {
      assertions = mkAssertions "plugins.alpha" [
        {
          assertion = layoutDefined || themeDefined;
          message = ''
            You have to either set a `theme` or define some sections in `layout`.
          '';
        }
        {
          assertion =
            !(
              themeDefined
              && (opts.settings.highestPrio == 1500 && builtins.length opts.settings.definitions == 1)
            );
          message = ''
            You can't define both a `theme` and custom options.
            Set `plugins.alpha.theme = null` if you want to configure alpha manually using the `layout` option.
          '';
        }
      ];

      plugins.alpha.luaConfig.content = ''
        require('alpha').setup(${toLuaObject (if themeDefined then cfg.theme else cfg.settings)});
        require('alpha.term')
      '';
    };
}
