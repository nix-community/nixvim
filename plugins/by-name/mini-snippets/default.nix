{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-snippets";
  moduleName = "mini.snippets";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    snippets = lib.nixvim.nestedLiteral (lib.literalExpression "lib.nixvim.emptyTable");

    mappings = {
      expand = "<C-j>";
      jump_next = "<C-l>";
      jump_prev = "<C-h>";
      stop = "<C-c>";
    };

    expand = {
      prepare = lib.nixvim.nestedLiteralLua "nil";
      match = lib.nixvim.nestedLiteralLua "nil";
      select = lib.nixvim.nestedLiteralLua "nil";
      insert = lib.nixvim.nestedLiteralLua "nil";
    };
  };
}
