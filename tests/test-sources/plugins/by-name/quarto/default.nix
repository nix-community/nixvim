{
  empty = {
    plugins = {
      quarto.enable = true;
      otter.enable = true;
      treesitter = {
        enable = true;
        settings.highlight.enable = true;
      };
    };
  };

  defaults = {
    plugins.quarto = {
      enable = true;

      settings = {
        debug = false;
        closePreviewOnExit = true;
        lspFeatures = {
          enabled = true;
          chunks = "curly";
          languages = [
            "r"
            "python"
            "julia"
            "bash"
            "html"
          ];
          diagnostics = {
            enabled = true;
            triggers = [ "BufWritePost" ];
          };
          completion = {
            enabled = true;
          };
        };
        codeRunner = {
          enabled = false;
          default_method = null;
          ft_runners = { };
          never_run = [ "yaml" ];
        };
      };
    };
  };

  example = {
    plugins = {
      otter.enable = true;
      treesitter = {
        enable = true;
        settings.highlight.enable = true;
      };

      quarto = {
        enable = true;

        settings = {
          debug = true;
          closePreviewOnExit = false;
          lspFeatures = {
            enabled = true;
            chunks = "curly";
            languages = [
              "r"
              "python"
              "julia"
            ];
            diagnostics = {
              enabled = true;
              triggers = [ "BufWritePost" ];
            };
            completion = {
              enabled = true;
            };
          };
          codeRunner = {
            enabled = true;
            default_method = "molten";
            ft_runners = {
              python = "molten";
            };
            never_run = [ "yaml" ];
          };
        };
      };
    };
  };
}
