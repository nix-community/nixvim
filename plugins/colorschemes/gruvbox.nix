{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "gruvbox";
  isColorscheme = true;
  package = "gruvbox-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  # Introduced January 31 2024
  # TODO remove in early March 2024.
  imports =
    map
      (
        optionName:
        lib.mkRemovedOptionModule [
          "colorschemes"
          "gruvbox"
          optionName
        ] "Please use `colorschemes.gruvbox.settings.${lib.nixvim.toSnakeCase optionName}` instead."
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

  settingsExample = {
    terminal_colors = true;
    palette_overrides = {
      dark1 = "#323232";
      dark2 = "#383330";
      dark3 = "#323232";
      bright_blue = "#5476b2";
      bright_purple = "#fb4934";
    };
  };
}
