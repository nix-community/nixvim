{
  lib,
  helpers,
  pkgs,
  config,
  ...
}:
with lib;
helpers.neovim-plugin.mkNeovimPlugin config {
  name = "poimandres";
  isColorscheme = true;
  originalName = "poimandres.nvim";
  defaultPackage = pkgs.vimPlugins.poimandres-nvim;

  maintainers = [ maintainers.GaetanLepage ];

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
    bold_vert_split = helpers.defaultNullOpts.mkBool false ''
      Use bold vertical separators.
    '';

    dim_nc_background = helpers.defaultNullOpts.mkBool false ''
      Dim 'non-current' window backgrounds.
    '';

    disable_background = helpers.defaultNullOpts.mkBool false ''
      Whether to disable the background.
    '';

    disable_float_background = helpers.defaultNullOpts.mkBool false ''
      Whether to disable the background for floats.
    '';

    disable_italics = helpers.defaultNullOpts.mkBool false ''
      Whether to disable italics.
    '';

    dark_variant = helpers.defaultNullOpts.mkStr "main" ''
      Dark variant.
    '';

    groups = helpers.mkNullOrOption (with types; attrsOf (either str (attrsOf str))) ''
      Which color to use for each group.

      default: see [source](https://github.com/olivercederborg/poimandres.nvim/blob/main/lua/poimandres/init.lua)
    '';

    highlight_groups = helpers.defaultNullOpts.mkAttrsOf types.str "{}" ''
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
