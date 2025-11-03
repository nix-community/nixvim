{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-files";
  moduleName = "mini.files";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    content = {
      filter = lib.nixvim.nestedLiteralLua "nil";
      highlight = lib.nixvim.nestedLiteralLua "nil";
      prefix = lib.nixvim.nestedLiteralLua "nil";
      sort = lib.nixvim.nestedLiteralLua "nil";
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
      max_number = lib.nixvim.nestedLiteralLua "math.huge";
      preview = false;
      width_focus = 50;
      width_nofocus = 15;
      width_preview = 25;
    };
  };
}
