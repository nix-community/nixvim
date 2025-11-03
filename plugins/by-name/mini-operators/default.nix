{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-operators";
  moduleName = "mini.operators";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    evaluate = {
      prefix = "g=";
      func = lib.nixvim.nestedLiteralLua "nil";
    };

    exchange = {
      prefix = "gx";
      reindent_linewise = true;
    };

    multiply = {
      prefix = "gm";
      func = lib.nixvim.nestedLiteralLua "nil";
    };

    replace = {
      prefix = "gr";
      reindent_linewise = true;
    };

    sort = {
      prefix = "gs";
      func = lib.nixvim.nestedLiteralLua "nil";
    };
  };
}
