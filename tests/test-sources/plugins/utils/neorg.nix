{
  empty = {
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
          floatPrecision = 0.01;
        };

        modules = {
          "core.defaults" = {__empty = null;};
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
      telescope.enable = false;

      neorg = {
        enable = false;
        modules."core.integrations.telescope".__empty = null;
      };
    };
  };
}
