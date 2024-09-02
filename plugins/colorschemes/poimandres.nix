{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts mkNullOrOption;
in
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "poimandres";
  isColorscheme = true;
  originalName = "poimandres.nvim";
  defaultPackage = pkgs.vimPlugins.poimandres-nvim;

  maintainers = [ lib.maintainers.GaetanLepage ];

  # TODO introduced 2024-04-15: remove 2024-06-15
  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    "boldVertSplit"
    "darkVariant"
    "disableBackground"
    "disableFloatBackground"
    "disableItalics"
    "dimNcBackground"
    "groups"
    "highlightGroups"
  ];

  settingsOptions = {
    bold_vert_split = defaultNullOpts.mkBool false ''
      Use bold vertical separators.
    '';

    dim_nc_background = defaultNullOpts.mkBool false ''
      Dim 'non-current' window backgrounds.
    '';

    disable_background = defaultNullOpts.mkBool false ''
      Whether to disable the background.
    '';

    disable_float_background = defaultNullOpts.mkBool false ''
      Whether to disable the background for floats.
    '';

    disable_italics = defaultNullOpts.mkBool false ''
      Whether to disable italics.
    '';

    dark_variant = defaultNullOpts.mkStr "main" ''
      Dark variant.
    '';

    groups = mkNullOrOption (with lib.types; attrsOf (either str (attrsOf str))) ''
      Which color to use for each group.

      default: see [source](https://github.com/olivercederborg/poimandres.nvim/blob/main/lua/poimandres/init.lua)
    '';

    highlight_groups = defaultNullOpts.mkAttrsOf lib.types.str { } ''
      Highlight groups.
    '';
  };

  settingsExample = {
    bold_vert_split = false;
    dim_nc_background = true;
    disable_background = false;
    disable_float_background = false;
    disable_italics = true;
  };
}
