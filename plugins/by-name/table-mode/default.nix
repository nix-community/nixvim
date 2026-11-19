{ lib, ... }:
lib.nixvim.plugins.mkVimPlugin {
  name = "table-mode";
  package = "vim-table-mode";

  globalPrefix = "table_mode_";

  maintainers = [ lib.maintainers.opdavies ];

  description = ''
    Create tables in Neovim as you type, with automatic re-alignment,
    formula evaluation and table sorting, plus commands and mappings to
    convert delimited lines to a table and back.

    Note: the plugin's `enable`/`disable`/`toggle` commands and mappings
    manage table mode per buffer; there is no global auto-enable option.
    To auto-enable for a filetype, run `:TableModeEnable` from that
    filetype's ftplugin or an autocommand.
  '';

  settingsExample = {
    auto_align = true;
    always_active = false;
    disable_mappings = false;
    delimiter = ",";
  };
}
