{
  lib,
  config,
  pkgs,
}:
let
  optionName = "`settings.fuzzy_finder`";

  fuzzyFinder = config.plugins.openscad.settings.fuzzy_finder;

  defaultPluginName =
    {
      skim = "skim-vim";
      fzf = "fzf-vim";
    }
    .${fuzzyFinder} or null;

  default =
    # If the user has not set `settings.fuzzy_finder`, do not pre-install a fuzzy-finder by default.
    if fuzzyFinder == null then
      null
    # Else, the value of `settings.fuzzy_finder` should be one of the supported options
    # (`skim` or `fzf`), else he has to provide a value (`null` or a package) to `fuzzyFinderPlugin`.
    else if defaultPluginName == null then
      throw ''
        We cannot automatically select a fuzzy finder plugin from the value given to `${optionName}`: "${fuzzyFinder}".
        Please, explicitly provide a value to the `plugins.openscad.fuzzyFinderPlugin`:
          - Either the package for the fuzzy finder plugin to be installed
          - or `null` if you do not want a plugin to be installed.
      ''
    # Case where we automatically select the default plugin to install.
    else
      [
        "vimPlugins"
        defaultPluginName
      ];

  defaultText = lib.literalMD ''
    - `pkgs.vimPlugins.skim-vim` if ${optionName} is `"skim"`
    - `pkgs.vimPlugins.fzf-vim` if ${optionName} is `"fzf"`
    - `null` otherwise
  '';
in
lib.mkPackageOption pkgs "fuzzy finder" {
  nullable = true;
  inherit default;
}
// {
  inherit defaultText;
}
