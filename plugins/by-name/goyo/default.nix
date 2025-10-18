{
  lib,
  helpers,
  ...
}:
with lib.nixvim.plugins;
with lib;
mkVimPlugin {
  name = "goyo";
  package = "goyo-vim";
  globalPrefix = "goyo_";
  description = "Distraction-free writing in Vim.";

  maintainers = [ maintainers.GaetanLepage ];

  settingsOptions = {
    width = helpers.mkNullOrOption types.ints.unsigned "width";

    height = helpers.mkNullOrOption types.ints.unsigned "height";

    linenr = helpers.defaultNullOpts.mkFlagInt 0 ''
      Show line numbers when in Goyo mode.
    '';
  };
}
