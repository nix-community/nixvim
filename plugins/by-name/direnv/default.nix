{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
in
lib.nixvim.plugins.mkVimPlugin {
  name = "direnv";
  package = "direnv-vim";
  globalPrefix = "direnv_";
  description = "A Neovim plugin for integrating Direnv with Neovim.";

  maintainers = [ lib.maintainers.alisonjenkins ];

  dependencies = [ "direnv" ];

  imports = [
    # TODO: added 2025-04-07, remove after 25.05
    (lib.nixvim.mkRemovedPackageOptionModule {
      plugin = "direnv";
      packageName = "direnv";
    })
  ];

  settingsOptions = {
    direnv_auto = defaultNullOpts.mkFlagInt 1 ''
      It will not execute `:DirenvExport` automatically if the value is `0`.
    '';

    direnv_edit_mode =
      defaultNullOpts.mkEnum
        [
          "edit"
          "split"
          "tabedit"
          "vsplit"
        ]
        "edit"
        ''
          Select the command to open buffers to edit. Default: 'edit'.
        '';

    direnv_silent_load = defaultNullOpts.mkFlagInt 1 ''
      Stop echoing output from Direnv command.
    '';
  };
}
