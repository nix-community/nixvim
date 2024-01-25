{
  lib,
  pkgs,
  ...
} @ args:
with lib;
with (import ../helpers.nix {inherit lib;}).vim-plugin;
  mkVimPlugin args {
    name = "ledger";
    description = "ledger language features";
    package = pkgs.vimPlugins.vim-ledger;

    globalPrefix = "ledger_";

    options = {
      maxWidth = mkDefaultOpt {
        global = "maxwidth";
        description = "Number of columns to display foldtext";
        type = types.int;
      };

      fillString = mkDefaultOpt {
        global = "fillstring";
        description = "String used to fill the space between account name and amount in the foldtext";
        type = types.int;
      };

      detailedFirst = mkDefaultOpt {
        global = "detailed_first";
        description = "Account completion sorted by depth instead of alphabetically";
        type = types.bool;
      };

      foldBlanks = mkDefaultOpt {
        global = "fold_blanks";
        description = "Hide blank lines following a transaction on a fold";
        type = types.bool;
      };
    };
  }
