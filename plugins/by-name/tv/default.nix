{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "tv";
  package = "tv-nvim";

  dependencies = [
    "fd"
    "television"
  ];

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    global_keybindings.channels = "<leader>tv";
    quickfix.auto_open = false;
    tv_binary = "tv";
  };
}
