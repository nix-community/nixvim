{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
(import ./_helpers.nix { inherit lib config pkgs; }).mkExtension {
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
    fuzzy = defaultNullOpts.mkBool true ''
      Whether to fuzzy search. False will do exact matching.
    '';

    override_generic_sorter = defaultNullOpts.mkBool true ''
      Override the generic sorter.
    '';

    override_file_sorter = defaultNullOpts.mkBool true ''
      Override the file sorter.
    '';

    case_mode = defaultNullOpts.mkEnumFirstDefault [
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

  extraConfig = cfg: {
    # Native library is in build/libfzf.so
    performance.combinePlugins.pathsToLink = [ "/build" ];
  };
}
