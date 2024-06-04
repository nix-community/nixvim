{
  config,
  helpers,
  pkgs,
  lib,
  ...
}:
with lib;
  helpers.vim-plugin.mkVimPlugin config {
    name = "direnv";
    originalName = "direnv.vim";
    defaultPackage = pkgs.vimPlugins.direnv-vim;
    globalPrefix = "direnv_";
    extraPackages = [pkgs.direnv];

    maintainers = [helpers.maintainers.alisonjenkins];

    settingsOptions = {
      direnv_auto = helpers.defaultNullOpts.mkBool true ''
        It will not execute :DirenvExport automatically if the value is false. Default: true.
      '';

      direnv_edit_mode =
        helpers.defaultNullOpts.mkEnum
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

      direnv_silent_load = helpers.defaultNullOpts.mkBool true ''
        Stop echoing output from Direnv command. Default: true
      '';
    };
  }
