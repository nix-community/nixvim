{
  helpers,
  pkgs,
  lib,
  ...
}:
with lib;
helpers.vim-plugin.mkVimPlugin {
  name = "direnv";
  originalName = "direnv.vim";
  package = "direnv-vim";
  globalPrefix = "direnv_";

  maintainers = [ helpers.maintainers.alisonjenkins ];

  settingsOptions = {
    direnv_auto = helpers.defaultNullOpts.mkFlagInt 1 ''
      It will not execute `:DirenvExport` automatically if the value is `0`.
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

    direnv_silent_load = helpers.defaultNullOpts.mkFlagInt 1 ''
      Stop echoing output from Direnv command.
    '';
  };

  extraOptions = {
    direnvPackage = lib.mkPackageOption pkgs "direnv" {
      nullable = true;
    };
  };

  extraConfig = cfg: {
    extraPackages = [ cfg.direnvPackage ];
  };
}
