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

  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "ledger";
      packageName = "ledger";
    })
  ];

  dependencies = [ "ledger" ];

  settingsExample = {
    detailed_first = 1;
    fold_blanks = 0;
    maxwidth = 80;
    fillstring = " ";
  };
}
