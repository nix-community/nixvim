{ config, lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "md-table-tidy";
  package = "md-table-tidy-nvim";

  maintainers = [ lib.maintainers.pierreborine ];

  description = "A lightweight Neovim plugin for formatting markdown tables.";

  settingsExample = {
    padding = 0;
    keymap = {
      table_tidy = "<leader>mt";
      table_tidy_all = "<leader>ma";
    };
  };

  extraConfig = {
    warnings = lib.nixvim.mkWarnings "plugins.md-table-tidy" [
      {
        when = !config.plugins.treesitter.enable;
        message = "This plugin needs treesitter to function as intended.";
      }
    ];
  };
}
