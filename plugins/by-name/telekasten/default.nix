{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "telekasten";
  package = "telekasten-nvim";
  description = "A Neovim plugin for working with a markdown zettelkasten/wiki and mixing it with a journal, based on telescope.nvim.";

  maintainers = [ lib.maintainers.onemoresuza ];

  settingsExample = {
    home = lib.nixvim.nestedLiteralLua ''vim.fn.expand("~/zettelkasten")'';
  };
}
