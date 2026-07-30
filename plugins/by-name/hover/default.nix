{ lib, ... }:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "hover";
  package = "hover-nvim";
  url = "https://github.com/lewis6991/hover.nvim";
  setup = ".config";

  description = /* markdown */ ''
    General framework for context aware hover providers (similar to vim.lsp.buf.hover).
    You should also create keybinds for:
    - `require("hover").open()`
    - `require("hover").enter()`
    - `require("hover").switch()`
    - `require("hover").switch("previous")`
    - `require("hover").switch("next")`

    Also, create a bind from `<MouseMove>` to `require("hover").mouse()` and set `opts.mousemoveevent = true`.
  '';

  maintainers = [ lib.maintainers.libewa ];

  settingsExample = {
    providers = [
      "hover.providers.diagnostic"
      "hover.providers.lsp"
      "hover.providers.dap"
      "hover.providers.man"
      "hover.providers.dictionary"
    ];
    preview_opts.border = "single";
    preview_window = false;
    title = true;
    mouse_providers = [ "hover.providers.lsp" ];
    mouse_delay = 1000;
  };
}
