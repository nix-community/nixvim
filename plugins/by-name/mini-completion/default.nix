{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "mini-completion";
  moduleName = "mini.completion";

  maintainers = [ lib.maintainers.HeitorAugustoLN ];

  settingsExample = {
    delay = {
      completion = 100;
      info = 100;
      signature = 50;
    };
    window = {
      info = {
        height = 25;
        width = 80;
        border = lib.nixvim.nestedLiteralLua "nil";
      };
      signature = {
        height = 25;
        width = 80;
        border = lib.nixvim.nestedLiteralLua "nil";
      };
    };
    lsp_completion = {
      source_func = "completefunc";
      auto_setup = true;
      process_items = lib.nixvim.nestedLiteralLua "nil";
      snippet_insert = lib.nixvim.nestedLiteralLua "nil";
    };
    fallback_action = "<C-n>";
    mappings = {
      force_twostep = "<C-Space>";
      force_fallback = "<A-Space>";
      scroll_down = "<C-f>";
      scroll_up = "<C-b>";
    };
  };
}
