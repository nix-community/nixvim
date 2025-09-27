{
  lib,
  ...
}:
let
  inherit (lib.nixvim) defaultNullOpts;
  inherit (lib) types;
in
lib.nixvim.plugins.mkVimPlugin {
  name = "easyescape";
  package = "vim-easyescape";
  globalPrefix = "easyescape_";
  description = "A plugin that makes exiting insert mode easy and distraction free!";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsOptions = {
    chars = defaultNullOpts.mkAttrsOf' {
      type = types.ints.unsigned;
      pluginDefault = {
        j = 1;
        k = 1;
      };
      example = {
        j = 2;
      };
      description = ''
        Which keys can be used to escape insert mode and how many times they need to be pressed.
      '';
    };

    timeout = defaultNullOpts.mkUnsignedInt 100 ''
      The unit of timeout is in ms.

      A very small timeout makes an input of real `jk` or `kj` possible (Python3 is required for
      this feature)!
    '';
  };

  settingsExample = {
    chars.j = 2;
    timeout = 2000;
  };
}
