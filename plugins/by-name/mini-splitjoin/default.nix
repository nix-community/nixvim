{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-splitjoin";
  moduleName = "mini.splitjoin";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    mappings = {
      toggle = "gS";
      split = "";
      join = "";
    };

    detect = {
      brackets = lib.nixvim.nestedLiteralLua "nil";
      separator = ",";
      exclude_regions = lib.nixvim.nestedLiteralLua "nil";
    };

    split = {
      hooks_pre = lib.nixvim.nestedLiteral (lib.literalExpression "lib.nixvim.emptyTable");
      hooks_post = lib.nixvim.nestedLiteral (lib.literalExpression "lib.nixvim.emptyTable");
    };

    join = {
      hooks_pre = lib.nixvim.nestedLiteral (lib.literalExpression "lib.nixvim.emptyTable");
      hooks_post = lib.nixvim.nestedLiteral (lib.literalExpression "lib.nixvim.emptyTable");
    };
  };
}
