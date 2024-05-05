{
  empty = {
    plugins.lsp.enable = true;
    plugins.lsp-format.enable = true;
  };

  example = {
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

        setup = {
          gopls = {
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
