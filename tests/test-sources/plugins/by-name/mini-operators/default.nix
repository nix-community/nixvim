{ lib }:
{
  empty = {
    plugins.mini-operators.enable = true;
  };

  defaults = {
    plugins.mini-operators = {
      enable = true;
      settings = {
        evaluate = {
          prefix = "g=";
          func = lib.nixvim.mkRaw "nil";
        };

        exchange = {
          prefix = "gx";
          reindent_linewise = true;
        };

        multiply = {
          prefix = "gm";
          func = lib.nixvim.mkRaw "nil";
        };

        replace = {
          prefix = "gr";
          reindent_linewise = true;
        };

        sort = {
          prefix = "gs";
          func = lib.nixvim.mkRaw "nil";
        };
      };
    };
  };
}
