{ lib }:
{
  empty = {
    plugins.mini-sessions.enable = true;
  };

  defaults = {
    plugins.mini-sessions = {
      enable = true;
      settings = {
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
            read = lib.nixvim.mkRaw "nil";
            write = lib.nixvim.mkRaw "nil";
            delete = lib.nixvim.mkRaw "nil";
          };

          post = {
            read = lib.nixvim.mkRaw "nil";
            write = lib.nixvim.mkRaw "nil";
            delete = lib.nixvim.mkRaw "nil";
          };
        };

        verbose = {
          read = false;
          write = true;
          delete = true;
        };
      };
    };
  };
}
