{ lib }:
{
  empty = {
    plugins.mini-visits.enable = true;
  };

  defaults = {
    plugins.mini-visits = {
      enable = true;
      settings = {
        list = {
          filter = lib.nixvim.mkRaw "nil";
          sort = lib.nixvim.mkRaw "nil";
        };

        silent = false;

        store = {
          autowrite = true;
          normalize = lib.nixvim.mkRaw "nil";
          path = lib.nixvim.mkRaw "vim.fn.stdpath('data') .. '/mini-visits-index'";
        };

        track = {
          event = "BufEnter";
          delay = 1000;
        };
      };
    };
  };
}
