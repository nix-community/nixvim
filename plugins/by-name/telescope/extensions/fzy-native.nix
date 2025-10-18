{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
  mkExtension = import ./_mk-extension.nix;
in
mkExtension {
  name = "fzy-native";
  extensionName = "fzy_native";
  package = "telescope-fzy-native-nvim";

  # TODO: introduced 2024-03-24, remove on 2024-05-24
  optionsRenamedToSettings = [
    "overrideFileSorter"
    "overrideGenericSorter"
  ];

  settingsOptions = {
    override_file_sorter = defaultNullOpts.mkBool true ''
      Whether to override the file sorter.
    '';

    override_generic_sorter = defaultNullOpts.mkBool true ''
      Whether to override the generic sorter.
    '';
  };

  settingsExample = {
    override_file_sorter = true;
    override_generic_sorter = false;
  };

  extraConfig = {
    # fzy-native itself is in deps directory
    performance.combinePlugins.pathsToLink = [ "/deps/fzy-lua-native" ];
  };
}
