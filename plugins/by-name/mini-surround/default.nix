{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-surround";
  moduleName = "mini.surround";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    n_lines = 50;
    respect_selection_type = true;
    search_method = "cover_or_next";
  };
}
