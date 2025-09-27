{
  config,
  lib,
  pkgs,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "timerly";
  package = "timerly";
  description = "Beautiful countdown timer plugin for Neovim.";

  settingsExample = {
    minutes = [
      30
      10
    ];
  };

  maintainers = [ lib.maintainers.FKouhai ];

}
