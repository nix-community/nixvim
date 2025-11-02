{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-visits";
  moduleName = "mini.visits";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    list = {
      filter = lib.nixvim.nestedLiteralLua "nil";
      sort = lib.nixvim.nestedLiteralLua "nil";
    };

    silent = false;

    store = {
      autowrite = true;
      normalize = lib.nixvim.nestedLiteralLua "nil";
      path = lib.nixvim.nestedLiteralLua "vim.fn.stdpath('data') .. '/mini-visits-index'";
    };

    track = {
      event = "BufEnter";
      delay = 1000;
    };
  };
}
