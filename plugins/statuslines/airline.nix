{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.plugins.airline;
  helpers = import ../helpers.nix {inherit lib;};

  sectionType = with types; nullOr (oneOf [str (listOf str)]);
  sectionOption = mkOption {
    default = null;
    type = sectionType;
    description = "Configuration for this section. Can be either a statusline-format string or a list of modules to be passed to airline#section#create_*.";
  };
in {
  options = {
    plugins.airline = {
      enable = mkEnableOption "airline";

      package = helpers.mkPackageOption "airline" pkgs.vimPlugins.vim-airline;

      extensions = mkOption {
        default = null;
        type = with types; nullOr attrs;
        description = "A list of extensions and their configuration";
      };

      onTop = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to show the statusline on the top instead of the bottom";
      };

      sections = mkOption {
        description = "Statusbar sections";
        default = null;
        type = with types;
          nullOr (submodule {
            options = {
              a = sectionOption;
              b = sectionOption;
              c = sectionOption;
              x = sectionOption;
              y = sectionOption;
              z = sectionOption;
            };
          });
      };

      powerline = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to use powerline symbols";
      };

      theme = mkOption {
        default = config.colorscheme;
        type = with types; nullOr str;
        description = "The theme to use for vim-airline. If set, vim-airline-themes will be installed.";
      };
    };
  };

  config = let
    sections = {};
  in
    mkIf cfg.enable {
      extraPlugins = with pkgs.vimPlugins;
        [
          cfg.package
        ]
        ++ optional (cfg.theme != null) vim-airline-themes;
      globals =
        {
          airline.extensions = cfg.extensions;

          airline_statusline_ontop = mkIf cfg.onTop 1;
          airline_powerline_fonts = mkIf cfg.powerline 1;

          airline_theme = mkIf (cfg.theme != null) cfg.theme;
        }
        // sections;
    };
}
