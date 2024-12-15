{
  lib,
  helpers,
  ...
}:
lib.nixvim.neovim-plugin.mkNeovimPlugin {
  name = "zellij";
  packPathName = "zellij.nvim";
  package = "zellij-nvim";

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
