{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts literalLua;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "persistence";
  package = "persistence-nvim";
  description = "A simple lua plugin for automated session management.";

  maintainers = [ lib.maintainers.jolars ];

  settingsOptions = {
    branch = defaultNullOpts.mkBool true ''
      Use git branch to save session.
    '';

    dir = defaultNullOpts.mkStr (literalLua "vim.fn.expand(vim.fn.stdpath('state') .. '/sessions/')") ''
      Directory where session files are saved.
    '';

    need = defaultNullOpts.mkUnsignedInt 1 ''
      Minimum number of file buffers that need to be open to save. Set to
      0 to always save.
    '';
  };

  settingsExample = {
    need = 0;
    branch = false;
  };
}
