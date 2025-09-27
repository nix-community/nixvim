{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "endec";
  package = "endec-nvim";

  maintainers = [ lib.maintainers.khaneliman ];

  settingsExample = {
    keymaps = {
      defaults = false;
      encode_base64_inplace = "gB";
    };
  };
}
