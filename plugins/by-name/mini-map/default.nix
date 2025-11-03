{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-map";
  moduleName = "mini.map";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    integrations = lib.nixvim.nestedLiteralLua "nil";

    symbols = {
      encode = lib.nixvim.nestedLiteralLua "nil";
      scroll_line = "█";
      scroll_view = "┃";
    };

    window = {
      focusable = false;
      side = "right";
      show_integration_count = true;
      width = 10;
      winblend = 25;
      zindex = 10;
    };
  };
}
