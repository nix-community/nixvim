{ lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "toggler";
  moduleName = "nvim-toggler";
  package = "nvim-toggler";

  maintainers = [ lib.maintainers.pierreborine ];

  description = "Invert text in vim, purely with lua";

  settingsExample = {
    inverses = {
      vim = "emacs";
      enabled = "disabled";
    };
    remove_default_keybinds = true;
    remove_default_inverses = true;
    autoselect_longest_match = false;
  };

  settingsOptions = {
    inverses = defaultNullOpts.mkAttrsOf lib.types.str { } ''
      Your own inverses.
    '';

    remove_default_keybinds = defaultNullOpts.mkBool false ''
      Removes the default <leader>i keymap.
    '';

    remove_default_inverses = defaultNullOpts.mkBool false ''
      Removes the default set of inverses.
    '';

    autoselect_longest_match = defaultNullOpts.mkBool false ''
      Auto-selects the longest match when there are multiple matches.
    '';
  };
}
