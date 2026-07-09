{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "multicursor";
  moduleName = "multicursor-nvim";
  package = "multicursor-nvim";

  description = ''
    Multiple cursors in Neovim which work how you expect.

    `setup()` accepts only `signs`, `shallowUndo`, and `hlsearch`. The plugin
    drives everything else (cursor operations, keymap layers, highlight groups)
    through its Lua API. Define keymaps and `mc.addKeymapLayer(...)` calls
    yourself, for example in `extraConfigLua`.
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
