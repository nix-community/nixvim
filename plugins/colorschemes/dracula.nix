{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) types;
  cfg = config.colorschemes.dracula;
in
{
  options = {
    colorschemes.dracula = {
      enable = lib.mkEnableOption "dracula";

      package = lib.nixvim.mkPluginPackageOption "dracula" pkgs.vimPlugins.dracula-vim;

      bold = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Include bold attributes in highlighting";
      };
      italic = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Include italic attributes in highlighting";
      };
      underline = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Include underline attributes in highlighting";
      };
      undercurl = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Include undercurl attributes in highlighting (only if underline enabled)";
      };

      fullSpecialAttrsSupport = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Explicitly declare full support for special attributes. On terminal emulators, set to 1 to allow underline/undercurl highlights without changing the foreground color";
      };

      highContrastDiff = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Use high-contrast color when in diff mode";
      };

      inverse = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Include inverse attributes in highlighting";
      };

      colorterm = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Include background fill colors";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    colorscheme = "dracula";
    extraPlugins = [ cfg.package ];

    globals = {
      dracula_bold = lib.mkIf (!cfg.bold) 0;
      dracula_italic = lib.mkIf (!cfg.italic) 0;
      dracula_underline = lib.mkIf (!cfg.underline) 0;
      dracula_undercurl = lib.mkIf (!cfg.undercurl) 0;
      dracula_full_special_attrs_support = lib.mkIf cfg.fullSpecialAttrsSupport 1;
      dracula_high_contrast_diff = lib.mkIf cfg.highContrastDiff 1;
      dracula_inverse = lib.mkIf (!cfg.inverse) 0;
      dracula_colorterm = lib.mkIf (!cfg.colorterm) 0;
    };

    opts.termguicolors = lib.mkDefault true;
  };
}
