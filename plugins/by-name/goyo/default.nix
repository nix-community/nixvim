{ lib, ... }:
let
  inherit (lib) types;
in
lib.nixvim.plugins.mkVimPlugin {
  name = "goyo";
  package = "goyo-vim";
  globalPrefix = "goyo_";
  description = "Distraction-free writing in Vim.";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    width = lib.nixvim.mkNullOrOption types.ints.unsigned "width";

    height = lib.nixvim.mkNullOrOption types.ints.unsigned "height";

    linenr = lib.nixvim.defaultNullOpts.mkFlagInt 0 ''
      Show line numbers when in Goyo mode.
    '';
  };
}
