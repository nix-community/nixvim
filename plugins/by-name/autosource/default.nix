{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkVimPlugin {
  name = "autosource";
  package = "vim-autosource";
  globalPrefix = "autosource_";
  description = "A Vim plugin that enables per project Vim configuration.";

  maintainers = [ lib.maintainers.refaelsh ];

  settingsOptions = {
    prompt_for_new_file = defaultNullOpts.mkFlagInt 1 ''
      The primary use-case of this option is to support automated testing.
      When set to false AutoSource will not prompt you when it detects a new file. The file will *NOT* be sourced.
    '';

    prompt_for_changed_file = defaultNullOpts.mkFlagInt 1 ''
      The primary use-case of this option is to support automated testing.
      When set to false AutoSource will not prompt you when it detects when a file is changed. The file will NOT be sourced.
    '';
  };
}
