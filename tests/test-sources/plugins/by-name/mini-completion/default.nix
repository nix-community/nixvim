{ lib }:
{
  empty = {
    plugins.mini-completion.enable = true;
  };

  defaults = {
    plugins.mini-completion = {
      enable = true;
      settings = {
        delay = {
          completion = 100;
          info = 100;
          signature = 50;
        };
        window = {
          info = {
            height = 25;
            width = 80;
            border = lib.nixvim.mkRaw "nil";
          };
          signature = {
            height = 25;
            width = 80;
            border = lib.nixvim.mkRaw "nil";
          };
        };
        lsp_completion = {
          source_func = "completefunc";
          auto_setup = true;
          process_items = lib.nixvim.mkRaw "nil";
          snippet_insert = lib.nixvim.mkRaw "nil";
        };
        fallback_action = "<C-n>";
        mappings = {
          force_twostep = "<C-Space>";
          force_fallback = "<A-Space>";
          scroll_down = "<C-f>";
          scroll_up = "<C-b>";
        };
      };
    };
  };
}
