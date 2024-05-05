{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.colorschemes.dracula;
in
{
  options = {
    colorschemes.dracula = {
      enable = mkEnableOption "dracula";

      package = helpers.mkPackageOption "dracula" pkgs.vimPlugins.dracula-vim;

      bold = mkOption {
        type = types.bool;
        default = true;
        description = "Include bold attributes in highlighting";
      };
      italic = mkOption {
        type = types.bool;
        default = true;
        description = "Include italic attributes in highlighting";
      };
      underline = mkOption {
        type = types.bool;
        default = true;
        description = "Include underline attributes in highlighting";
      };
      undercurl = mkOption {
        type = types.bool;
        default = true;
        description = "Include undercurl attributes in highlighting (only if underline enabled)";
      };

      fullSpecialAttrsSupport = mkOption {
        type = types.bool;
        default = false;
        description = "Explicitly declare full support for special attributes. On terminal emulators, set to 1 to allow underline/undercurl highlights without changing the foreground color";
      };

      highContrastDiff = mkOption {
        type = types.bool;
        default = false;
        description = "Use high-contrast color when in diff mode";
      };

      inverse = mkOption {
        type = types.bool;
        default = true;
        description = "Include inverse attributes in highlighting";
      };

      colorterm = mkOption {
        type = types.bool;
        default = true;
        description = "Include background fill colors";
      };
    };
  };

  config = mkIf cfg.enable {
    colorscheme = "dracula";
    extraPlugins = [ cfg.package ];

    globals = {
      dracula_bold = mkIf (!cfg.bold) 0;
      dracula_italic = mkIf (!cfg.italic) 0;
      dracula_underline = mkIf (!cfg.underline) 0;
      dracula_undercurl = mkIf (!cfg.undercurl) 0;
      dracula_full_special_attrs_support = mkIf cfg.fullSpecialAttrsSupport 1;
      dracula_high_contrast_diff = mkIf cfg.highContrastDiff 1;
      dracula_inverse = mkIf (!cfg.inverse) 0;
      dracula_colorterm = mkIf (!cfg.colorterm) 0;
    };

    opts.termguicolors = mkDefault true;
  };
}
