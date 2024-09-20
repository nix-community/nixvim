{
  empty = {
    plugins.telescope = {
      enable = true;
      extensions.fzf-native.enable = true;
    };
    plugins.web-devicons.enable = true;
  };

  defaults = {
    plugins.telescope = {
      enable = true;

      extensions.fzf-native = {
        enable = true;

        settings = {
          fuzzy = true;
          override_generic_sorter = true;
          override_file_sorter = true;
          case_mode = "smart_case";
        };
      };
    };
    plugins.web-devicons.enable = true;
  };

  combine-plugins = {
    plugins.telescope = {
      enable = true;
      extensions.fzf-native.enable = true;
    };
    plugins.web-devicons.enable = true;

    performance.combinePlugins.enable = true;
  };
}
