let
  mkExtension = import ./_mk-extension.nix;
in
mkExtension {
  name = "ui-select";
  package = "telescope-ui-select-nvim";

  settingsExample = {
    specific_opts.codeactions = false;
  };
}
