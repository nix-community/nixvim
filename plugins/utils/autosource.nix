{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  mkBoolInt = defaultNullOpts.mkEnum [
    0
    1
  ];
in
lib.nixvim.vim-plugin.mkVimPlugin {
  name = "autosource";
  originalName = "vim-autosource";
  package = "vim-autosource";
  globalPrefix = "autosource_";

  maintainers = [ lib.nixvim.maintainers.refaelsh ];

  settingsOptions = {
    prompt_for_new_file = mkBoolInt 1 ''
      The primary use-case of this option is to support automated testing.
      When set to false AutoSource will not prompt you when it detects a new file. The file will *NOT* be sourced.
    '';

    prompt_for_changed_file = mkBoolInt 1 ''
      The primary use-case of this option is to support automated testing.
      When set to false AutoSource will not prompt you when it detects when a file is changed. The file will NOT be sourced.
    '';
  };
}
