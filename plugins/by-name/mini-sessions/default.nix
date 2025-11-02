{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-sessions";
  moduleName = "mini.sessions";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    autoread = false;
    autowrite = true;
    file = "Session.vim";

    force = {
      read = false;
      write = true;
      delete = false;
    };

    hooks = {
      pre = {
        read = lib.nixvim.nestedLiteralLua "nil";
        write = lib.nixvim.nestedLiteralLua "nil";
        delete = lib.nixvim.nestedLiteralLua "nil";
      };

      post = {
        read = lib.nixvim.nestedLiteralLua "nil";
        write = lib.nixvim.nestedLiteralLua "nil";
        delete = lib.nixvim.nestedLiteralLua "nil";
      };
    };

    verbose = {
      read = false;
      write = true;
      delete = true;
    };
  };
}
