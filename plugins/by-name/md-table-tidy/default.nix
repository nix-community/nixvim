{ config, lib, ... }:
let
  inherit (lib.nixvim) defaultNullOpts;
in
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

  settingsOptions = {
    padding = defaultNullOpts.mkUnsignedInt 1 "Number of spaces for cell padding";

    keymap = {
      table_tidy = defaultNullOpts.mkStr "<leader>tt" ''
        Key for command :TableTidy<CR>
      '';

      table_tidy_all = defaultNullOpts.mkStr "<leader>ta" ''
        Key for command :TableTidyAll<CR>
      '';
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
