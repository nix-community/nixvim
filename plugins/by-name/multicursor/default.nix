{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "multicursor";
  moduleName = "multicursor-nvim";
  package = "multicursor-nvim";

  description = ''
    Multiple cursors in Neovim which work how you expect.

    Most of this plugin's functionality (adding/skipping/matching cursors,
    keymap layers, highlight groups, ...) is driven imperatively through its
    Lua API rather than `setup()` options, so users are expected to wire up
    `mc.addKeymapLayer(...)`, keymaps and highlight overrides themselves via
    `extraConfigLua`. `setup()` itself only accepts a small set of options.
  '';

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = lib.literalExpression ''
    {
      signs = [
        "┆"
        "│"
        "┃"
        "↑"
        "↓"
        "⇡"
        "⇣"
      ];
      shallowUndo = false;
      hlsearch = false;
    }
  '';
}
