{ lib, ... }:
{
  empty = {
    plugins.mini-files.enable = true;
  };

  defaults = {
    plugins.mini-files = {
      enable = true;
      settings = {
        content = {
          filter = lib.nixvim.mkRaw "nil";
          highlight = lib.nixvim.mkRaw "nil";
          prefix = lib.nixvim.mkRaw "nil";
          sort = lib.nixvim.mkRaw "nil";
        };

        mappings = {
          close = "q";
          go_in = "l";
          go_in_plus = "L";
          go_out = "h";
          go_out_plus = "H";
          mark_goto = "'";
          mark_set = "m";
          reset = "<BS>";
          reveal_cwd = "@";
          show_help = "g?";
          synchronize = "=";
          trim_left = "<";
          trim_right = ">";
        };

        options = {
          permanent_delete = true;
          use_as_default_explorer = true;
        };

        windows = {
          max_number = lib.nixvim.mkRaw "math.huge";
          preview = false;
          width_focus = 50;
          width_nofocus = 15;
          width_preview = 25;
        };
      };
    };
  };
}
