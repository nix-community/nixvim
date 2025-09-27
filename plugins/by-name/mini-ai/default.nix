{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-ai";
  moduleName = "mini.ai";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    n_line = 500;
    search_method = "cover_or_nearest";
    silent = true;
  };
}
