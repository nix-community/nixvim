{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
  mkExtension = import ./_mk-extension.nix;
in
mkExtension {
  name = "fzf-native";
  extensionName = "fzf";
  package = "telescope-fzf-native-nvim";

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

  extraConfig = {
    # Native library is in build/libfzf.so
    performance.combinePlugins.pathsToLink = [ "/build" ];
  };
}
