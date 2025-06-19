{
  lib,
  helpers,
  ...
}:
with lib.nixvim.plugins;
with lib;
mkVimPlugin {
  name = "goyo";
  packPathName = "goyo.vim";
  package = "goyo-vim";
  globalPrefix = "goyo_";
  description = "Distraction-free writing in Vim.";

  maintainers = [ maintainers.GaetanLepage ];

  # TODO introduced 2024-03-01: remove 2024-05-01
  deprecateExtraConfig = true;
  optionsRenamedToSettings = [
    "width"
    "height"
    {
      old = "showLineNumbers";
      new = "linenr";
    }
  ];

  settingsOptions = {
    width = helpers.mkNullOrOption types.ints.unsigned "width";

    height = helpers.mkNullOrOption types.ints.unsigned "height";

    linenr = helpers.defaultNullOpts.mkFlagInt 0 ''
      Show line numbers when in Goyo mode.
    '';
  };
}
