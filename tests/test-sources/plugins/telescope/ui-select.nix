{
  empty = {
    plugins.telescope = {
      enable = true;
      extensions.ui-select.enable = true;
    };
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
  };
}
