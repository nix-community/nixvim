{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.programs.nixvim.plugins.airline;
  helpers = import ../helpers.nix { inherit lib; };

  sectionType = with types; nullOr (oneOf [ str (listOf str)]);
  sectionOption = mkOption {
    default = null;
    type = sectionType;
    description = "Configuration for this section. Can be either a statusline-format string or a list of modules to be passed to airline#section#create_*.";
  };
in {
  options = {
    programs.nixvim.plugins.airline = {
      enable = mkEnableOption "Enable airline";

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
        default = null;
        type = with types; nullOr (submodule {
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
        default = null;
        type = with types; nullOr bool;
        description = "Whether to use powerline symbols";
      };

      theme = mkOption {
        default = config.programs.nixvim.colorscheme;
        type = with types; nullOr str;
        description = "The theme to use for vim-airline. If set, vim-airline-themes will be installed.";
      };
    };
  };

  config = let
    sections = {};
  in mkIf cfg.enable {
    programs.nixvim = {
      extraPlugins = with pkgs.vimPlugins; [
        vim-airline
      ] ++ optional (!isNull cfg.theme) vim-airline-themes;
      globals = {
        airline.extensions = cfg.extensions;

        airline_statusline_ontop = mkIf cfg.onTop 1;
        airline_powerline_fonts = mkIf (cfg.powerline) 1;

        airline_theme = mkIf (!isNull cfg.theme) cfg.theme;
      } // sections;
    };
  };
}
