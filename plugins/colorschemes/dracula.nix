{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkVimPlugin {
  name = "dracula";
  package = "dracula-vim";
  isColorscheme = true;
  globalPrefix = "dracula_";

  maintainers = [ lib.maintainers.GaetanLepage ];

  optionsRenamedToSettings = [
    "bold"
    "italic"
    "underline"
    "undercurl"
    "fullSpecialAttrsSupport"
    "highContrastDiff"
    "inverse"
    "colorterm"
  ];

  settingsOptions = {
    bold = defaultNullOpts.mkBool true ''
      Include bold attributes in highlighting.
    '';

    italic = defaultNullOpts.mkBool true ''
      Include italic attributes in highlighting.
    '';

    strikethrough = defaultNullOpts.mkBool true ''
      Include strikethrough attributes in highlighting.
    '';

    underline = defaultNullOpts.mkBool true ''
      Include underline attributes in highlighting.
    '';

    undercurl = defaultNullOpts.mkBool true ''
      Include undercurl attributes in highlighting (only if `underline` is enabled).
    '';

    full_special_attrs_support = defaultNullOpts.mkBool false ''
      Explicitly declare full support for special attributes.
      On terminal emulators, set to `true` to allow `underline`/`undercurl` highlights without
      changing the foreground color.
    '';

    high_contrast_diff = defaultNullOpts.mkBool false ''
      Use high-contrast color when in diff mode.
    '';

    inverse = defaultNullOpts.mkBool true ''
      Include inverse attributes in highlighting.
    '';

    colorterm = defaultNullOpts.mkBool true ''
      Include background fill colors.
    '';
  };

  settingsExample = {
    italic = false;
    colorterm = false;
  };

  extraConfig = {
    opts.termguicolors = lib.mkDefault true;
  };
}
