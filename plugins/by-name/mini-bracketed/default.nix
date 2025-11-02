{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-bracketed";
  moduleName = "mini.bracketed";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    buffer = {
      suffix = "b";
      options = lib.nixvim.nestedLiteral (lib.literalExpression "lib.nixvim.emptyTable");
    };
    comment = {
      suffix = "c";
      options = lib.nixvim.nestedLiteral (lib.literalExpression "lib.nixvim.emptyTable");
    };
    conflict = {
      suffix = "x";
      options = lib.nixvim.nestedLiteral (lib.literalExpression "lib.nixvim.emptyTable");
    };
    diagnostic = {
      suffix = "d";
      options = lib.nixvim.nestedLiteral (lib.literalExpression "lib.nixvim.emptyTable");
    };
    file = {
      suffix = "f";
      options = lib.nixvim.nestedLiteral (lib.literalExpression "lib.nixvim.emptyTable");
    };
    indent = {
      suffix = "i";
      options = lib.nixvim.nestedLiteral (lib.literalExpression "lib.nixvim.emptyTable");
    };
    jump = {
      suffix = "j";
      options = lib.nixvim.nestedLiteral (lib.literalExpression "lib.nixvim.emptyTable");
    };
    location = {
      suffix = "l";
      options = lib.nixvim.nestedLiteral (lib.literalExpression "lib.nixvim.emptyTable");
    };
    oldfile = {
      suffix = "o";
      options = lib.nixvim.nestedLiteral (lib.literalExpression "lib.nixvim.emptyTable");
    };
    quickfix = {
      suffix = "q";
      options = lib.nixvim.nestedLiteral (lib.literalExpression "lib.nixvim.emptyTable");
    };
    treesitter = {
      suffix = "t";
      options = lib.nixvim.nestedLiteral (lib.literalExpression "lib.nixvim.emptyTable");
    };
    undo = {
      suffix = "u";
      options = lib.nixvim.nestedLiteral (lib.literalExpression "lib.nixvim.emptyTable");
    };
    window = {
      suffix = "w";
      options = lib.nixvim.nestedLiteral (lib.literalExpression "lib.nixvim.emptyTable");
    };
    yank = {
      suffix = "y";
      options = lib.nixvim.nestedLiteral (lib.literalExpression "lib.nixvim.emptyTable");
    };
  };
}
