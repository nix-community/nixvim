{ lib, ... }:
{
  empty = {
    plugins.mini-notify.enable = true;
  };

  defaults = {
    plugins.mini-notify = {
      enable = true;
      settings = {
        content = {
          format = lib.nixvim.mkRaw "nil";
          sort = lib.nixvim.mkRaw "nil";
        };

        lsp_progress = {
          enable = true;
          level = "INFO";
          duration_last = 1000;
        };

        window = {
          config = lib.nixvim.emptyTable;
          max_width_share = 0.382;
          winblend = 25;
        };
      };
    };
  };
}
