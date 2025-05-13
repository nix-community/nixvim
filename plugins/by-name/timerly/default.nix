{
  config,
  lib,
  pkgs,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "timerly";
  packPathName = "timerly.nvim";
  package = "timerly";

  settingsExample = {
    minutes = [
      30
      10
    ];
  };

  maintainers = [ lib.maintainers.FKouhai ];

}
