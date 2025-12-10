{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-cmdline";
  moduleName = "mini.cmdline";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    autocomplete.enable = true;
    autocorrect.enable = true;
    autopeek.enable = true;
  };
}
