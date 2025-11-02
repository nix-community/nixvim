{ lib, ... }:
{
  empty = {
    plugins.mini-hipatterns.enable = true;
  };

  defaults = {
    plugins.mini-hipatterns = {
      enable = true;
      settings = {
        highlighters = lib.nixvim.emptyTable;

        delay = {
          text_change = 200;
          scroll = 50;
        };
      };
    };
  };
}
