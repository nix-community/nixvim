{
  lib,
  config,
  options,
  pkgs,
  ...
}:
let
  inherit (lib) types mkOption;

  cfg = config.plugins.alpha;

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
        description = "Type of section";
      };

      val = lib.nixvim.mkNullOrOption (
        with types;
        nullOr (oneOf [

          # "button", "text"
          (maybeRaw str)
          # "padding"
          int
          (listOf (
            either
              # "text" (list of strings)
              str
              # "group"
              (attrsOf anything)
          ))
        ])
      ) "Value for section";

      opts = mkOption {
        type = with types; attrsOf anything;
        default = { };
        description = "Additional options for the section";
      };
    };
  };
in
{
  options = {
    plugins.alpha = {
      enable = lib.mkEnableOption "alpha-nvim";

      package = lib.mkPackageOption pkgs "alpha-nvim" {
        default = [
          "vimPlugins"
          "alpha-nvim"
        ];
      };

      # TODO: deprecated 2024-08-29 remove after 24.11
      iconsEnabled = mkOption {
        type = types.bool;
        description = "Toggle icon support. Installs nvim-web-devicons.";
        visible = false;
      };

      theme = mkOption {
        type = with types; nullOr (maybeRaw str);
        apply = v: if lib.isString v then lib.nixvim.mkRaw "require'alpha.themes.${v}'.config" else v;
        default = null;
        example = "dashboard";
        description = "You can directly use a pre-defined theme.";
      };

      layout = mkOption {
        type = with types; either (maybeRaw str) (listOf sectionType);
        default = [ ];
        description = "List of sections to layout for the dashboard";
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
      };

      opts = lib.nixvim.mkNullOrOption (with types; attrsOf anything) ''
        Optional global options.
      '';
    };
  };

  config =
    let
      layoutDefined = cfg.layout != [ ];
      themeDefined = cfg.theme != null;

      opt = options.plugins.alpha;
    in
    lib.mkIf cfg.enable {

      # TODO: added 2024-09-20 remove after 24.11
      warnings = lib.optionals opt.iconsEnabled.isDefined [
        ''
          The option definition `plugins.alpha.iconsEnabled' in ${lib.showFiles opt.iconsEnabled.files} has been deprecated; please remove it.
        ''
      ];
      plugins.web-devicons =
        lib.mkIf
          (
            opt.iconsEnabled.isDefined
            && cfg.iconsEnabled
            && !(
              config.plugins.mini.enable
              && config.plugins.mini.modules ? icons
              && config.plugins.mini.mockDevIcons
            )
          )
          {
            enable = lib.mkOverride 1490 true;
          };

      extraPlugins = [ cfg.package ];

      assertions = [
        {
          assertion = themeDefined || layoutDefined;
          message = ''
            Nixvim (plugins.alpha): You have to either set a `theme` or define some sections in `layout`.
          '';
        }
        {
          assertion = !(themeDefined && layoutDefined);
          message = ''
            Nixvim (plugins.alpha): You can't define both a `theme` and custom options.
            Set `plugins.alpha.theme = null` if you want to configure alpha manually using the `layout` option.
          '';
        }
      ];

      extraConfigLua =
        let
          setupOptions =
            if themeDefined then
              cfg.theme
            else
              (with cfg; {
                inherit layout opts;
              });
        in
        ''
          require('alpha').setup(${lib.nixvim.toLuaObject setupOptions})
          require('alpha.term')
        '';
    };
}
