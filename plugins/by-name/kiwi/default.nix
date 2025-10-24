{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "kiwi";
  package = "kiwi-nvim";

  maintainers = [ lib.maintainers.GaetanLepage ];

  settingsExample = [
    {
      name = "work";
      path = "work-wiki";
    }
    {
      name = "personal";
      path = "personal-wiki";
    }
  ];
}
