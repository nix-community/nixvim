{
  lib,
  config,
  pkgs,
  ...
}:
(import ./_helpers.nix { inherit lib config pkgs; }).mkExtension {
  name = "ui-select";
  package = "telescope-ui-select-nvim";

  settingsExample = {
    specific_opts.codeactions = false;
  };
}
