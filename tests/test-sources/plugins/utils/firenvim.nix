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

  check-alias =
    { config, ... }:
    {
      assertions = [
        {
          assertion = config.globals ? firenvim_config;
          message = "`firenvim_config` should be present in globals";
        }
        {
          assertion = config.globals.firenvim_config.globalSettings.alt or null == "all";
          message = "`globalSettings` should be have set `alt = \"all\"`";
        }
        {
          assertion = config.globals.firenvim_config.localSettings.".*".cmdline or null == "neovim";
          message = "`localSettings` should be have set `\".*\".cmdline = \"neovim\"`";
        }
      ];

      plugins.firenvim = {
        enable = true;

        settings = {
          globalSettings.alt = "all";
          localSettings.".*".cmdline = "neovim";
        };
      };
    };
}
