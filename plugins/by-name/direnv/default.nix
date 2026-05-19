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

  settingsOptions = {
    auto = defaultNullOpts.mkFlagInt 1 ''
      It will not execute `:DirenvExport` automatically if the value is `0`.
    '';

    edit_mode =
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

    silent_load = defaultNullOpts.mkFlagInt 0 ''
      Stop echoing output from Direnv command.
    '';
  };
}
