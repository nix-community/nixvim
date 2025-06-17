{ lib, ... }:
let
  inherit (lib) types;
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "cmp-tabby";
  description = "[Tabby](https://tabbyml.com) completion source for the nvim-cmp.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  imports = [
    { cmpSourcePlugins.cmp_tabby = "cmp-tabby"; }
  ];

  deprecateExtraOptions = true;
  optionsRenamedToSettings = [
    "host"
    "maxLines"
    "runOnEveryKeyStroke"
    "stop"
  ];

  moduleName = "cmp_tabby.config";
  setup = ":setup";

  settingsOptions = {
    host = defaultNullOpts.mkStr "http://localhost:5000" ''
      The address of the tabby host server.
    '';

    max_lines = defaultNullOpts.mkUnsignedInt 100 ''
      The max number of lines to complete.
    '';

    run_on_every_keystroke = defaultNullOpts.mkBool true ''
      Whether to run the completion on every keystroke.
    '';

    stop = defaultNullOpts.mkListOf types.str [ "\n" ] ''
      Stop character.
    '';
  };

  settingsExample = {
    host = "http://localhost:5000";
    max_lines = 100;
    run_on_every_keystroke = true;
    stop = [ "\n" ];
  };
}
