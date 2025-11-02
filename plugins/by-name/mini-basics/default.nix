{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-basics";
  moduleName = "mini.basics";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    options = {
      basic = true;
      extra_ui = false;
      win_borders = "auto";
    };
    mappings = {
      basic = true;
      option_toggle_prefix = "\\";
      windows = false;
      move_with_alt = false;
    };
    autocommands = {
      basic = true;
      relnum_in_visual_mode = false;
    };
    silent = false;
  };
}
