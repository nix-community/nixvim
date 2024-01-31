{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.colorschemes.gruvbox;
in {
  meta.maintainers = [maintainers.GaetanLepage];

  # Introduced January 31 2024
  # TODO remove in early March 2024.
  imports =
    map
    (
      optionName:
        mkRemovedOptionModule
        ["colorschemes" "gruvbox" optionName]
        "Please use `colorschemes.gruvox.settings.${helpers.toSnakeCase optionName}` instead."
    )
    [
      "italics"
      "bold"
      "underline"
      "undercurl"
      "contrastDark"
      "contrastLight"
      "highlightSearchCursor"
      "numberColumn"
      "signColumn"
      "colorColumn"
      "vertSplitColor"
      "italicizeComments"
      "italicizeStrings"
      "invertSelection"
      "invertSigns"
      "invertIndentGuides"
      "invertTabline"
      "improvedStrings"
      "improvedWarnings"
      "transparentBg"
      "trueColor"
    ];

  options.colorschemes.gruvbox = {
    enable = mkEnableOption "gruvbox.nvim";

    package = helpers.mkPackageOption "gruvbox.nvim" pkgs.vimPlugins.gruvbox-nvim;

    settings = mkOption {
      type = with types;
        submodule {
          freeformType = attrs;
          options = {};
        };
      description = "The configuration options for gruvbox.";
      default = {};
      example = {
        terminal_colors = true;
        palette_overrides = {
          dark1 = "#323232";
          dark2 = "#383330";
          dark3 = "#323232";
          bright_blue = "#5476b2";
          bright_purple = "#fb4934";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    colorscheme = "gruvbox";
    extraPlugins = [cfg.package];

    extraConfigLua = ''
      require('gruvbox').setup(${helpers.toLuaObject cfg.settings})
    '';
  };
}
