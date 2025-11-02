{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-hipatterns";
  moduleName = "mini.hipatterns";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    highlighters = lib.nixvim.nestedLiteral (lib.literalExpression "lib.nixvim.emptyTable");

    delay = {
      text_change = 200;
      scroll = 50;
    };
  };
}
