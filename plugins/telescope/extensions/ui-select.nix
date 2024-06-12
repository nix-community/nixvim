{
  lib,
  helpers,
  config,
  pkgs,
  ...
}:
(import ./_helpers.nix {
  inherit
    lib
    helpers
    config
    pkgs
    ;
}).mkExtension
  {
    name = "ui-select";
    defaultPackage = pkgs.vimPlugins.telescope-ui-select-nvim;

    settingsExample = {
      specific_opts.codeactions = false;
    };
  }
