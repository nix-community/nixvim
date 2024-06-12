{
  empty = {
    # neorg should be re-packaged in nixpkgs from the luarocks `neorg` package.
    # In the meantime, disable the test.
    # TODO: re-enable when this will have been fixed upstream.
    tests.dontRun = true;

    plugins.neorg.enable = true;
  };

  example = {
    # neorg should be re-packaged in nixpkgs from the luarocks `neorg` package.
    # In the meantime, disable the test.
    # TODO: re-enable when this will have been fixed upstream.
    tests.dontRun = true;

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
      telescope.enable = false;

      neorg = {
        enable = false;
        modules."core.integrations.telescope".__empty = null;
      };
    };
  };
}
