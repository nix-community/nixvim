{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkNeovimPlugin {
  name = "lastplace";
  moduleName = "nvim-lastplace";
  package = "nvim-lastplace";

  maintainers = [ lib.maintainers.khaneliman ];

  description = ''
    A Neovim plugin that automatically opens files at your last edit position.
  '';

  settingsOptions = {
    lastplace_ignore_buftype = defaultNullOpts.mkListOf types.str [
      "quickfix"
      "nofix"
      "help"
    ] "The list of buffer types to ignore by lastplace.";

    lastplace_ignore_filetype = defaultNullOpts.mkListOf types.str [
      "gitcommit"
      "gitrebase"
      "svn"
      "hgcommit"
    ] "The list of file types to ignore by lastplace.";

    lastplace_open_folds = defaultNullOpts.mkBool true "Whether closed folds are automatically opened when jumping to the last edit position.";
  };

  settingsExample = {
    settings = {
      lastplace_ignore_buftype = [
        "help"
      ];
      lastplace_ignore_filetype = [
        "svn"
      ];
      lastplace_open_folds = false;
    };
  };

  # TODO: Deprecated 2025-02-01
  inherit (import ./deprecations.nix { inherit lib; })
    imports
    deprecateExtraOptions
    ;
}
