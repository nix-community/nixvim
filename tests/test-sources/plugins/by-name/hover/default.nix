{
  empty = {
    plugins.hover.enable = true;
  };

  defaults = {
    plugins.hover = {
      enable = true;
      settings = {
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
    };
  };

  example = {
    plugins.hover = {
      keymaps.open = "K";
      enableMouse = true;
    };
  };
}
