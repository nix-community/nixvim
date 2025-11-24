{ lib }:
{
  empty = {
    plugins.mini-snippets.enable = true;
  };

  defaults = {
    plugins.mini-snippets = {
      enable = true;
      settings = {
        snippets = lib.nixvim.emptyTable;

        mappings = {
          expand = "<C-j>";
          jump_next = "<C-l>";
          jump_prev = "<C-h>";
          stop = "<C-c>";
        };

        expand = {
          prepare = lib.nixvim.mkRaw "nil";
          match = lib.nixvim.mkRaw "nil";
          select = lib.nixvim.mkRaw "nil";
          insert = lib.nixvim.mkRaw "nil";
        };
      };
    };
  };
}
