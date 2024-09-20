{
  empty = {
    plugins.telescope = {
      enable = true;
      extensions.ui-select.enable = true;
    };
    plugins.web-devicons.enable = true;
  };

  example = {
    plugins.telescope = {
      enable = true;

      extensions.ui-select = {
        enable = true;

        settings = {
          specific_opts.codeactions = false;
        };
      };
    };
    plugins.web-devicons.enable = true;
  };
}
