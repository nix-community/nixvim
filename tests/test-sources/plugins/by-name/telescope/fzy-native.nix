{
  empty = {
    plugins.telescope = {
      enable = true;
      extensions.fzy-native.enable = true;
    };
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
  };

  combine-plugins = {
    plugins.telescope = {
      enable = true;
      extensions.fzy-native.enable = true;
    };

    performance.combinePlugins.enable = true;
  };
}
