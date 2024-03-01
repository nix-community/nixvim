{
  lib,
  config,
  helpers,
  pkgs,
  ...
}:
with helpers.vim-plugin;
with lib;
  mkVimPlugin config {
    name = "goyo";
    originalName = "goyo.vim";
    defaultPackage = pkgs.vimPlugins.goyo-vim;
    globalPrefix = "goyo_";

    # TODO introduced 2024-03-01: remove 2024-05-01
    deprecateExtraConfig = true;
    optionsRenamedToSettings = [
      "width"
      "height"
    ];
    imports = [
      (
        mkRenamedOptionModule
        ["plugins" "goyo" "showLineNumbers"]
        ["plugins" "goyo" "settings" "linenr"]
      )
    ];

    settingsOptions = {
      width = helpers.mkNullOrOption types.ints.unsigned "width";

      height = helpers.mkNullOrOption types.ints.unsigned "height";

      linenr = helpers.defaultNullOpts.mkBool false ''
        Show line numbers when in Goyo mode.
      '';
    };
  }
