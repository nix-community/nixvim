{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-move";
  moduleName = "mini.move";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    mappings = {
      left = "<M-h>";
      right = "<M-l>";
      down = "<M-j>";
      up = "<M-k>";

      line_left = "<M-h>";
      line_right = "<M-l>";
      line_down = "<M-j>";
      line_up = "<M-k>";
    };

    options = {
      reindent_linewise = true;
    };
  };
}
