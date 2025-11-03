{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-animate";
  moduleName = "mini.animate";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    cursor.enable = true;
    scroll.enable = true;
    resize.enable = true;
    open.enable = true;
    close.enable = true;
  };
}
