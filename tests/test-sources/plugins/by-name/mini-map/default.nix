{ lib }:
{
  empty = {
    plugins.mini-map.enable = true;
  };

  defaults = {
    plugins.mini-map = {
      enable = true;
      settings = {
        integrations = lib.nixvim.mkRaw "nil";

        symbols = {
          encode = lib.nixvim.mkRaw "nil";
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
    };
  };
}
