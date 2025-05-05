{
  legacy-empty = {
    plugins.lsp.enable = true;
    plugins.lsp-format.enable = true;
  };

  legacy-example = {
    plugins = {
      lsp = {
        enable = true;

        servers.gopls = {
          enable = true;
          onAttach.function = ''
            x = 12
          '';
        };
      };

      lsp-format = {
        enable = true;

        settings = {
          go = {
            exclude = [ "gopls" ];
            order = [
              "gopls"
              "efm"
            ];
            sync = true;
            force = true;

            # Test the ability to provide extra options for each filetype
            someRandomOption = 42;
          };
        };
      };
    };
  };

  empty = {
    plugins.lspconfig.enable = true;
    plugins.lsp-format.enable = true;
  };

  none = {
    plugins.lspconfig.enable = true;
    plugins.lsp-format = {
      enable = true;
      lspServersToEnable = "none";
    };
  };

  example = {
    plugins = {
      lspconfig.enable = true;
      lsp.servers.gopls.enable = true;

      lsp-format = {
        enable = true;

        settings = {
          go = {
            exclude = [ "gopls" ];
            order = [
              "gopls"
              "efm"
            ];
            sync = true;
            force = true;

            # Test the ability to provide extra options for each filetype
            someRandomOption = 42;
          };
        };
      };
    };
  };
}
