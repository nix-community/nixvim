{
  pkgs,
  lib,
  ...
} @ args:
with lib;
with import ../helpers.nix {inherit lib;};
  mkPlugin args {
    name = "ledger";
    description = "ledger language features";
    package = pkgs.vimPlugins.vim-ledger;

    options = {
      maxWidth = mkDefaultOpt {
        global = "ledger_maxwidth";
        description = "Number of columns to display foldtext";
        type = types.int;
      };

      fillString = mkDefaultOpt {
        global = "ledger_fillstring";
        description = "String used to fill the space between account name and amount in the foldtext";
        type = types.int;
      };

      detailedFirst = mkDefaultOpt {
        global = "ledger_detailed_first";
        description = "Account completion sorted by depth instead of alphabetically";
        type = types.bool;
      };

      foldBlanks = mkDefaultOpt {
        global = "ledger_fold_blanks";
        description = "Hide blank lines following a transaction on a fold";
        type = types.bool;
      };
    };
  }
