{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-indentscope";
  moduleName = "mini.indentscope";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    draw = {
      delay = 100;
      predicate = lib.nixvim.nestedLiteralLua "function (scope) return not scope.body.is_incomplete end";
      priority = 2;
    };

    mappings = {
      object_scope = "ii";
      object_scope_with_border = "ai";
      goto_top = "[i";
      goto_bottom = "]i";
    };

    options = {
      border = "both";
      indent_at_cursor = true;
      n_lines = 10000;
      try_as_border = false;
    };

    symbol = "╎";
  };
}
