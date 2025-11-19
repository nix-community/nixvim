{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "zellij";
  package = "zellij-nvim";
  description = "Zellij integration for Neovim.";

  maintainers = [ lib.maintainers.hmajid2301 ];

  settingsOptions = {
    path = lib.nixvim.defaultNullOpts.mkStr "zellij" ''
      Path to the zellij binary.
    '';

    replaceVimWindowNavigationKeybinds = lib.nixvim.defaultNullOpts.mkBool false ''
      Will set keybinds like `<C-w>h` to left.
    '';

    vimTmuxNavigatorKeybinds = lib.nixvim.defaultNullOpts.mkBool false ''
      Will set keybinds like `<C-h>` to left.
    '';

    debug = lib.nixvim.defaultNullOpts.mkBool false ''
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
