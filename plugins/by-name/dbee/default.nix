{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "dbee";
  package = "nvim-dbee";
  description = "Interactive database client for Neovim.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    default_connection = "wtg";
    sources = [
      (lib.nixvim.nestedLiteralLua "require('dbee.sources').FileSource:new(vim.fn.stdpath('cache') .. '/dbee/persistence.json')")
    ];
  };
}
