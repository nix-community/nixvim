{
  empty = {
    # Tries to download metadata
    test.runNvim = false;

    plugins.devdocs.enable = true;
  };

  defaults = {
    # Tries to download metadata
    test.runNvim = false;

    plugins.devdocs = {
      enable = true;

      settings = {
        ensure_installed.__empty = { };
      };
    };
  };

  example = {
    # Tries to download metadata
    test.runNvim = false;

    plugins.devdocs = {
      enable = true;

      settings = {
        ensure_installed = [
          "go"
          "html"
          "http"
          "lua~5.1"
        ];
      };
    };
  };
}
