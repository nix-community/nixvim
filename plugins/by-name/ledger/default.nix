{
  lib,
  ...
}:
lib.nixvim.plugins.mkVimPlugin {
  name = "ledger";
  package = "vim-ledger";
  globalPrefix = "ledger_";
  description = "Filetype detection, syntax highlighting, auto-formatting, auto-completion, and other tools for working with ledger files.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  dependencies = [ "ledger" ];

  settingsExample = {
    detailed_first = 1;
    fold_blanks = 0;
    maxwidth = 80;
    fillstring = " ";
  };
}
