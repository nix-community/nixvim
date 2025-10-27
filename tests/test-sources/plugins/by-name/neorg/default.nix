{
  empty = {
    # Treesitter is required when using the "core.defaults" module.
    plugins.treesitter.enable = true;
    plugins.neorg.enable = true;
  };

  defaults = {
    plugins = {

      # Treesitter is required when using the "core.defaults" module.
      treesitter.enable = true;

      neorg = {
        enable = true;

        settings = {
          hook.__raw = "nil";
          lazy_loading = false;
          load.__empty = { };
          logger = {
            plugin = "neorg";
            use_console = true;
            highlights = true;
            use_file = true;
            level = "warn";
            modes = [
              {
                name = "trace";
                hl = "Comment";
                level.__raw = "vim.log.levels.TRACE";
              }
              {
                name = "debug";
                hl = "Comment";
                level.__raw = "vim.log.levels.DEBUG";
              }
              {
                name = "info";
                hl = "None";
                level.__raw = "vim.log.levels.INFO";
              }
              {
                name = "warn";
                hl = "WarningMsg";
                level.__raw = "vim.log.levels.WARN";
              }
              {
                name = "error";
                hl = "ErrorMsg";
                level.__raw = "vim.log.levels.ERROR";
              }
              {
                name = "fatal";
                hl = "ErrorMsg";
                level = 5;
              }
            ];

            float_precision = 0.01;
          };
        };
      };
    };
  };

  example = {
    plugins = {

      # Treesitter is required when using the "core.defaults" module.
      treesitter.enable = true;

      neorg = {
        enable = true;

        settings = {
          lazy_loading = true;

          load = {
            "core.defaults".__empty = null;
            "core.concealer".config = {
              icon_preset = "varied";
            };
            "core.dirman".config = {
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
        settings.load."core.integrations.telescope".__empty = null;
        telescopeIntegration.enable = true;
      };

      web-devicons.enable = true;
    };
  };
}
