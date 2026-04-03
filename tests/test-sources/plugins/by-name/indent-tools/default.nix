{
  empty = {
    # TODO: upstream needs update to support nvim-treesitter-textobjects namespace:
    # local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"
    test.runNvim = false;
    plugins.indent-tools.enable = true;
  };

  defaults = {
    # TODO: upstream needs update to support nvim-treesitter-textobjects namespace:
    # local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"
    test.runNvim = false;
    plugins.indent-tools = {
      enable = true;

      settings = {
        normal = {
          up = "[i";
          down = "]i";
          repeatable = true;
        };
        textobj = {
          ii = "ii";
          ai = "ai";
        };
      };
    };
  };

  example = {
    # TODO: upstream needs update to support nvim-treesitter-textobjects namespace:
    # local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"
    test.runNvim = false;
    plugins.indent-tools = {
      enable = true;

      settings = {
        textobj = {
          ii = "iI";
          ai = "aI";
        };
        normal = {
          up = false;
          down = false;
        };
      };
    };
  };
}
