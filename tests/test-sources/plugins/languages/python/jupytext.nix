{
  empty = {
    plugins.jupytext.enable = true;
  };

  defaults = {
    plugins.jupytext = {
      enable = true;

      settings = {
        style = "hydrogen";
        output_extension = "auto";
        force_ft = null;
        custom_language_formatting = { };
      };
    };
  };

  example = {
    plugins.jupytext = {
      enable = true;

      settings = {
        style = "light";
        output_extension = "auto";
        force_ft = null;
        custom_language_formatting.python = {
          extension = "md";
          style = "markdown";
          force_ft = "markdown";
        };
      };
    };
  };
}
