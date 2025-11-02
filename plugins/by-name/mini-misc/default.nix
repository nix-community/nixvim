{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-misc";
  moduleName = "mini.misc";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    make_global = [
      "put"
      "put_text"
    ];
  };
}
