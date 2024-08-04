{
  empty = {
    plugins.firenvim.enable = true;
  };

  example = {
    plugins.firenvim = {
      enable = true;

      settings = {
        globalSettings.alt = "all";
        localSettings = {
          ".*" = {
            cmdline = "neovim";
            content = "text";
            priority = 0;
            selector = "textarea";
            takeover = "always";
          };
          "https?://[^/]+\\.co\\.uk/" = {
            takeover = "never";
            priority = 1;
          };
        };
      };
    };
  };
}
