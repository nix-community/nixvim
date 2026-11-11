{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkVimPlugin {
  name = "vim-be-better";
  package = "vim-be-better";
  description = ''
    A comprehensive vim training plugin featuring game-based exercises to improve your vim skills through structured practice and challenges. It was created on top of the fork of vim-be-good plugin.
    Features 25+ games to improve your vim-commands and motions.
  '';
  maintainers = [ lib.maintainers.AngyySB ];
  globalPrefix = "vim_be_better_";
  settingsOptions = {
    log_file = defaultNullOpts.mkBool false ''
      Enable logging for debugging.
    '';
    default_difficulty = defaultNullOpts.mkStr "easy" ''
      Default difficulty for games.
    '';
  };
  settingsExample = {
    default_difficulty = "medium";
  };
}
