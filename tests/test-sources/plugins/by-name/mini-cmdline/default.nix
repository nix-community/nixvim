{ lib }:
{
  empty = {
    plugins.mini-cmdline.enable = true;
  };

  defaults = {
    plugins.mini-cmdline = {
      enable = true;

      settings = {
        autocomplete = {
          enable = true;
          delay = 0;
          predicate = lib.nixvim.mkRaw "nil";
          map_arrows = true;
        };

        autocorrect = {
          enable = true;
          func = lib.nixvim.mkRaw "nil";
        };

        autopeek = {
          enable = true;
          n_context = 1;

          window = {
            config = lib.nixvim.emptyTable;
            statuscolumn = lib.nixvim.mkRaw "nil";
          };
        };
      };
    };
  };

  example = {
    plugins.mini-cmdline = {
      enable = true;

      settings = {
        autocomplete.enable = true;
        autocorrect.enable = true;
        autopeek.enable = true;
      };
    };
  };
}
