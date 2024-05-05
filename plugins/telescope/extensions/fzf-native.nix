{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
(import ./_helpers.nix {
  inherit
    lib
    helpers
    config
    pkgs
    ;
})
.mkExtension
{
  name = "fzf-native";
  extensionName = "fzf";
  defaultPackage = pkgs.vimPlugins.telescope-fzf-native-nvim;

  # TODO: introduced 2024-03-24, remove on 2024-05-24
  optionsRenamedToSettings = [
    "fuzzy"
    "overrideGenericSorter"
    "overrideFileSorter"
    "caseMode"
  ];

  settingsOptions = {
    fuzzy = helpers.defaultNullOpts.mkBool true ''
      Whether to fuzzy search. False will do exact matching.
    '';

    override_generic_sorter = helpers.defaultNullOpts.mkBool true ''
      Override the generic sorter.
    '';

    override_file_sorter = helpers.defaultNullOpts.mkBool true ''
      Override the file sorter.
    '';

    case_mode = helpers.defaultNullOpts.mkEnumFirstDefault [
      "smart_case"
      "ignore_case"
      "respect_case"
    ] "Case mode.";
  };

  settingsExample = {
    fuzzy = false;
    override_generic_sorter = true;
    override_file_sorter = false;
    case_mode = "ignore_case";
  };
}
