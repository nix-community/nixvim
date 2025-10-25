{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "showkeys";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    timeout = 5;
    maxkeys = 5;
    position = "bottom-center";
    keyformat."<CR>" = "Enter";
  };
}
