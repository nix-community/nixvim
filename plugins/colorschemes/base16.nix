{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.colorschemes.base16;
  helpers = import ../helpers.nix {inherit lib;};
  themes = import ./base16-list.nix;
in {
  options = {
    colorschemes.base16 = {
      enable = mkEnableOption "base16";

      package = helpers.mkPackageOption "base16" pkgs.vimPlugins.nvim-base16;

      useTruecolor = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to use truecolor for the colorschemes. If set to false, you'll need to set up base16 in your shell.";
      };

      colorscheme = mkOption {
        type = types.enum themes;
        description = "The base16 colorscheme to use";
        default = head themes;
      };

      setUpBar = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to install the matching plugin for your statusbar. This does nothing as of yet, waiting for upstream support.";
      };

      customColorScheme =
        helpers.mkNullOrOption
        (with types;
          submodule {
            options =
              listToAttrs
              (
                map
                (
                  colorId: rec {
                    name = "base0" + colorId;
                    value = mkOption {
                      type = types.str;
                      description = "The value for color ${name}.";
                      example = "#16161D";
                    };
                  }
                )
                ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "A" "B" "C" "D" "E" "F"]
              );
          })
        ''
          Optionaly, you can provide a table specifying your colors to the setup function.

          Example:
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
    };
  };

  config = mkIf cfg.enable {
    colorscheme = "base16-${cfg.colorscheme}";
    extraPlugins = [cfg.package];

    plugins.airline.theme = mkIf cfg.setUpBar "base16";
    plugins.lightline.colorscheme = null;

    options.termguicolors = mkIf cfg.useTruecolor true;

    extraConfigLua = mkIf (cfg.customColorScheme != null) ''
      require('base16-colorscheme').setup(${helpers.toLuaObject cfg.customColorScheme})
    '';
  };
}
