{
  empty = {
    plugins.telescope = {
      enable = true;
      extensions.ast-grep.enable = true;
    };
    plugins.web-devicons.enable = true;
  };

  combine-plugins = {
    plugins.telescope = {
      enable = true;
      extensions.ast-grep.enable = true;
    };

    plugins.web-devicons.enable = true;
    performance.combinePlugins.enable = true;
  };
}
