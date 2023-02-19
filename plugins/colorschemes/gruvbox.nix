{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.colorschemes.gruvbox;
  helpers = import ../helpers.nix {inherit lib;};
  colors = types.enum ["bg" "red" "green" "yellow" "blue" "purple" "aqua" "gray" "fg" "bg0_h" "bg0" "bg1" "bg2" "bg3" "bg4" "gray" "orange" "bg0_s" "fg0" "fg1" "fg2" "fg3" "fg4"];
in {
  options = {
    colorschemes.gruvbox = {
      enable = mkEnableOption "gruvbox";

      package = helpers.mkPackageOption "gruvbox" pkgs.vimPlugins.gruvbox-nvim;

      italics = mkEnableOption "italics";
      bold = mkEnableOption "bold";
      underline = mkEnableOption "underlined text";
      undercurl = mkEnableOption "undercurled text";

      contrastDark = mkOption {
        type = types.nullOr (types.enum ["soft" "medium" "hard"]);
        default = null;
        description = "Contrast for the dark mode";
      };

      contrastLight = mkOption {
        type = types.nullOr (types.enum ["soft" "medium" "hard"]);
        default = null;
        description = "Contrast for the light mode";
      };

      highlightSearchCursor = mkOption {
        type = types.nullOr colors;
        default = null;
        description = "The cursor background while search is highlighted";
      };

      numberColumn = mkOption {
        type = types.nullOr colors;
        default = null;
        description = "The number column background";
      };

      signColumn = mkOption {
        type = types.nullOr colors;
        default = null;
        description = "The sign column background";
      };

      colorColumn = mkOption {
        type = types.nullOr colors;
        default = null;
        description = "The color column background";
      };

      vertSplitColor = mkOption {
        type = types.nullOr colors;
        default = null;
        description = "The vertical split background color";
      };

      italicizeComments = mkOption {
        type = types.bool;
        default = true;
        description = "Italicize comments";
      };

      italicizeStrings = mkOption {
        type = types.bool;
        default = false;
        description = "Italicize strings";
      };

      invertSelection = mkOption {
        type = types.bool;
        default = true;
        description = "Invert the select text";
      };

      invertSigns = mkOption {
        type = types.bool;
        default = false;
        description = "Invert GitGutter and Syntastic signs";
      };

      invertIndentGuides = mkOption {
        type = types.bool;
        default = false;
        description = "Invert indent guides";
      };

      invertTabline = mkOption {
        type = types.bool;
        default = false;
        description = "Invert tabline highlights";
      };

      improvedStrings = mkOption {
        type = types.bool;
        default = false;
        description = "Improved strings";
      };

      improvedWarnings = mkOption {
        type = types.bool;
        default = false;
        description = "Improved warnings";
      };

      transparentBg = mkEnableOption "transparent background";

      trueColor = mkEnableOption "true color support";
    };
  };

  config = mkIf cfg.enable {
    colorscheme = "gruvbox";
    extraPlugins = [cfg.package];

    globals = {
      gruvbox_bold = mkIf (!cfg.bold) 0;
      gruvbox_italic = mkIf (cfg.italics) 1;
      gruvbox_underline = mkIf (cfg.underline) 1;
      gruvbox_undercurl = mkIf (cfg.undercurl) 1;
      gruvbox_transparent_bg = mkIf (cfg.transparentBg) 0;
      gruvbox_contrast_dark = mkIf (!isNull cfg.contrastDark) cfg.contrastDark;
      gruvbox_contrast_light = mkIf (!isNull cfg.contrastLight) cfg.contrastLight;
      gruvbox_hls_cursor = mkIf (!isNull cfg.highlightSearchCursor) cfg.highlightSearchCursor;
      gruvbox_number_column = mkIf (!isNull cfg.numberColumn) cfg.numberColumn;
      gruvbox_sign_column = mkIf (!isNull cfg.signColumn) cfg.signColumn;
      gruvbox_color_column = mkIf (!isNull cfg.colorColumn) cfg.colorColumn;
      gruvbox_vert_split = mkIf (!isNull cfg.vertSplitColor) cfg.vertSplitColor;

      gruvbox_italicize_comments = mkIf (!cfg.italicizeComments) 0;
      gruvbox_italicize_strings = mkIf (cfg.italicizeStrings) 1;
      gruvbox_invert_selection = mkIf (!cfg.invertSelection) 0;
      gruvbox_invert_signs = mkIf (cfg.invertSigns) 1;
      gruvbox_invert_indent_guides = mkIf (cfg.invertIndentGuides) 1;
      gruvbox_invert_tabline = mkIf (cfg.invertTabline) 1;
      gruvbox_improved_strings = mkIf (cfg.improvedStrings) 1;
      gruvbox_improved_warnings = mkIf (cfg.improvedWarnings) 1;
    };
  };
}
