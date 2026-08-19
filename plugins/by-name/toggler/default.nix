{ lib, ... }:
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
}
