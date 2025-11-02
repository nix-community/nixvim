{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-notify";
  moduleName = "mini.notify";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    content = {
      format = lib.nixvim.nestedLiteralLua "nil";
      sort = lib.nixvim.nestedLiteralLua "nil";
    };

    lsp_progress = {
      enable = true;
      level = "INFO";
      duration_last = 1000;
    };

    window = {
      config = lib.literalExpression "lib.nixvim.emptyTable";
      max_width_share = 0.382;
      winblend = 25;
    };
  };
}
