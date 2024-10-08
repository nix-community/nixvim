{
  empty = {
    # Treesitter is required when using the "core.defaults" module.
    plugins.treesitter.enable = true;
    plugins.neorg.enable = true;
  };

  example = {
    plugins = {
      # Treesitter is required when using the "core.defaults" module.
      treesitter.enable = true;

      neorg = {
        enable = true;

        lazyLoading = false;
        logger = {
          plugin = "neorg";
          useConsole = true;
          highlights = true;
          useFile = true;
          level = "warn";
          modes = {
            trace = {
              hl = "Comment";
              level = "trace";
            };
            debug = {
              hl = "Comment";
              level = "debug";
            };
            info = {
              hl = "None";
              level = "info";
            };
            warn = {
              hl = "WarningMsg";
              level = "warn";
            };
            error = {
              hl = "ErrorMsg";
              level = "error";
            };
            fatal = {
              hl = "ErrorMsg";
              level = 5;
            };
          };
          floatPrecision = 1.0e-2;
        };

        modules = {
          "core.defaults" = {
            __empty = null;
          };
          "core.dirman" = {
            config = {
              workspaces = {
                work = "~/notes/work";
                home = "~/notes/home";
              };
            };
          };
        };
      };
    };
  };

  telescope-integration = {
    plugins = {
      # Treesitter is required when using the "core.defaults" module.
      treesitter.enable = true;
      telescope.enable = true;

      neorg = {
        enable = true;
        modules."core.integrations.telescope".__empty = null;
      };

      web-devicons.enable = true;
    };
  };

  no-packages = {
    # Treesitter is required when using the "core.defaults" module.
    plugins.treesitter.enable = true;

    plugins.neorg = {
      enable = true;
      neorgTelescopePackage = null;
    };
  };
}
