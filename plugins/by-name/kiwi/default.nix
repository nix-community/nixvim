{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "kiwi";
  package = "kiwi-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = {
    __unkeyed-1 = {
      name = "work";
      path = "work-wiki";
    };
    __unkeyed-2 = {
      name = "personal";
      path = "personal-wiki";
    };
  };
}
