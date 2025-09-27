{
  lib,
  helpers,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "zellij";
  package = "zellij-nvim";
  description = "Zellij integration for Neovim.";

  maintainers = [ lib.maintainers.hmajid2301 ];

  settingsOptions = {
    path = helpers.defaultNullOpts.mkStr "zellij" ''
      Path to the zellij binary.
    '';

    replaceVimWindowNavigationKeybinds = helpers.defaultNullOpts.mkBool false ''
      Will set keybinds like `<C-w>h` to left.
    '';

    vimTmuxNavigatorKeybinds = helpers.defaultNullOpts.mkBool false ''
      Will set keybinds like `<C-h>` to left.
    '';

    debug = helpers.defaultNullOpts.mkBool false ''
      Will log things to `/tmp/zellij.nvim`.
    '';
  };

  settingsExample = {
    path = "zellij";
    replaceVimWindowNavigationKeybinds = true;
    vimTmuxNavigatorKeybinds = false;
    debug = true;
  };
}
