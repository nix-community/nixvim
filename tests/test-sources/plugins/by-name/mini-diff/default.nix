{ lib }:
{
  empty = {
    plugins.mini-diff.enable = true;
  };

  defaults = {
    plugins.mini-diff = {
      enable = true;
      settings = {
        view = {
          style = lib.nixvim.mkRaw "vim.go.number and 'number' or 'sign'";
          signs = {
            add = "▒";
            change = "▒";
            delete = "▒";
          };
          priority = 199;
        };
        source = lib.nixvim.mkRaw "nil";
        delay = {
          text_change = 200;
        };
        mappings = {
          apply = "gh";
          reset = "gH";
          textobject = "gh";
          goto_first = "[H";
          goto_prev = "[h";
          goto_next = "]h";
          goto_last = "]H";
        };
        options = {
          algorithm = "histogram";
          indent_heuristic = true;
          linematch = 60;
          wrap_goto = false;
        };
      };
    };
  };
}
