{
  lib,
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
    width = lib.nixvim.mkNullOrOption types.ints.unsigned "width";

    height = lib.nixvim.mkNullOrOption types.ints.unsigned "height";

    linenr = lib.nixvim.defaultNullOpts.mkFlagInt 0 ''
      Show line numbers when in Goyo mode.
    '';
  };
}
