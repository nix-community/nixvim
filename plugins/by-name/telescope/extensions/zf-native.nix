{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
  mkExtension = import ./_mk-extension.nix;
in
mkExtension {
  name = "zf-native";
  extensionName = "zf-native";
  package = "telescope-zf-native-nvim";

  settingsOptions = {
    file = {
      enable = defaultNullOpts.mkBool true ''
        Override default telescope file sorter.
      '';
      highlight_results = defaultNullOpts.mkBool true ''
        Highlight matching text in results.
      '';
      match_filename = defaultNullOpts.mkBool true ''
        Enable zf filename match priority.
      '';
      initial_sort = defaultNullOpts.mkBool null ''
        Optional function to define a sort order when the query is empty.
      '';
      smart_case = defaultNullOpts.mkBool true ''
        Set to false to enable case sensitive matching.
      '';
    };

    generic = {
      enable = defaultNullOpts.mkBool true ''
        Override default telescope generic item sorter.
      '';
      highlight_results = defaultNullOpts.mkBool true ''
        Highlight matching text in results.
      '';
      match_filename = defaultNullOpts.mkBool false ''
        Disable zf filename match priority.
      '';
      initial_sort = defaultNullOpts.mkBool null ''
        Optional function to define a sort order when the query is empty.
      '';
      smart_case = defaultNullOpts.mkBool true ''
        Set to false to enable case sensitive matching.
      '';
    };
  };

  settingsExample = {
    file = {
      enable = true;
      highlight_results = true;
      match_filename = true;
      initial_sort = null;
      smart_case = true;
    };
    generic = {
      enable = true;
      highlight_results = true;
      match_filename = false;
      initial_sort = null;
      smart_case = true;
    };
  };

  dependencies = [ "zf" ];

  extraConfig = cfg: {
    # zf-native shared binaries
    performance.combinePlugins.pathsToLink = [ "/lib" ];
  };
}
