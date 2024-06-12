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
}).mkExtension
  {
    name = "fzy-native";
    extensionName = "fzy_native";
    defaultPackage = pkgs.vimPlugins.telescope-fzy-native-nvim;

    # TODO: introduced 2024-03-24, remove on 2024-05-24
    optionsRenamedToSettings = [
      "overrideFileSorter"
      "overrideGenericSorter"
    ];

    settingsOptions = {
      override_file_sorter = helpers.defaultNullOpts.mkBool true ''
        Whether to override the file sorter.
      '';

      override_generic_sorter = helpers.defaultNullOpts.mkBool true ''
        Whether to override the generic sorter.
      '';
    };

    settingsExample = {
      override_file_sorter = true;
      override_generic_sorter = false;
    };
  }
