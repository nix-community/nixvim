{
  empty = {
    plugins.telescope = {
      enable = true;
      extensions.fzy-native.enable = true;
    };
    plugins.web-devicons.enable = true;
  };

  example = {
    plugins.telescope = {
      enable = true;

      extensions.fzy-native = {
        enable = true;

        settings = {
          override_file_sorter = true;
          override_generic_sorter = false;
        };
      };
    };
    plugins.web-devicons.enable = true;
  };

  combine-plugins = {
    plugins.telescope = {
      enable = true;
      extensions.fzy-native.enable = true;
    };

    plugins.web-devicons.enable = true;
    performance.combinePlugins.enable = true;
  };
}
