{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-diff";
  moduleName = "mini.diff";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    view = {
      style = lib.nixvim.nestedLiteralLua "vim.go.number and 'number' or 'sign'";
      signs = {
        add = "▒";
        change = "▒";
        delete = "▒";
      };
      priority = 199;
    };
    source = lib.nixvim.nestedLiteralLua "nil";
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
}
