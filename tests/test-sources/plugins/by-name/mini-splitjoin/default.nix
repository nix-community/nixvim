{ lib }:
{
  empty = {
    plugins.mini-splitjoin.enable = true;
  };

  defaults = {
    plugins.mini-splitjoin = {
      enable = true;
      settings = {
        mappings = {
          toggle = "gS";
          split = "";
          join = "";
        };

        detect = {
          brackets = lib.nixvim.mkRaw "nil";
          separator = ",";
          exclude_regions = lib.nixvim.mkRaw "nil";
        };

        split = {
          hooks_pre = lib.nixvim.emptyTable;
          hooks_post = lib.nixvim.emptyTable;
        };

        join = {
          hooks_pre = lib.nixvim.emptyTable;
          hooks_post = lib.nixvim.emptyTable;
        };
      };
    };
  };
}
