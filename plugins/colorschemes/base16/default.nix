{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
# We configure this plugin manually (no `settings` option) so there is no point in using
# `mkNeovimPlugin` here.
  helpers.vim-plugin.mkVimPlugin config {
    name = "base16";
    isColorscheme = true;
    originalName = "base16.nvim";
    defaultPackage = pkgs.vimPlugins.base16-nvim;

    maintainers = [maintainers.GaetanLepage];

    # We manually set the colorscheme if needed.
    colorscheme = null;

    # TODO introduced 2024-03-12: remove 2024-05-12
    imports = let
      basePluginPath = ["colorschemes" "base16"];
    in [
      (
        mkRenamedOptionModule
        (basePluginPath ++ ["customColorScheme"])
        (basePluginPath ++ ["colorscheme"])
      )
      (
        mkRenamedOptionModule
        (basePluginPath ++ ["useTruecolor"])
        ["options" "termguicolors"]
      )
    ];

    extraOptions = {
      colorscheme = let
        customColorschemeType = types.submodule {
          options =
            listToAttrs
            (
              map
              (
                colorId: rec {
                  name = "base0" + colorId;
                  value = mkOption {
                    type = types.str;
                    description = "The value for color `${name}`.";
                    example = "#16161D";
                  };
                }
              )
              ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "A" "B" "C" "D" "E" "F"]
            );
        };
      in
        mkOption {
          type = with types;
            either
            (enum (import ./theme-list.nix))
            customColorschemeType;
          description = ''
            The base16 colorscheme to use.
            It can either be the name of a builtin colorscheme or an attrs specifying each color explicitly.

            Example for the latter:
            ```nix
              {
                base00 = "#16161D";
                base01 = "#2c313c";
                base02 = "#3e4451";
                base03 = "#6c7891";
                base04 = "#565c64";
                base05 = "#abb2bf";
                base06 = "#9a9bb3";
                base07 = "#c5c8e6";
                base08 = "#e06c75";
                base09 = "#d19a66";
                base0A = "#e5c07b";
                base0B = "#98c379";
                base0C = "#56b6c2";
                base0D = "#0184bc";
                base0E = "#c678dd";
                base0F = "#a06949";
              }
            ```
          '';
          example = "edge-light";
        };

      setUpBar = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to set your status bar theme to 'base16'.";
      };
    };

    extraConfig = cfg:
      mkMerge [
        {
          plugins.airline.settings.theme = mkIf cfg.setUpBar "base16";
          plugins.lualine.theme = mkIf cfg.setUpBar "base16";
          plugins.lightline.colorscheme = null;

          opts.termguicolors = mkDefault true;
        }
        (mkIf (isString cfg.colorscheme) {
          colorscheme = "base16-${cfg.colorscheme}";
        })
        (mkIf (isAttrs cfg.colorscheme) {
          extraConfigLuaPre = ''
            require('base16-colorscheme').setup(${helpers.toLuaObject cfg.colorscheme})
          '';
        })
      ];
  }
