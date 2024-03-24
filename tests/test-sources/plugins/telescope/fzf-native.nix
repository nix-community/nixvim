{
  empty = {
    plugins.telescope = {
      enable = true;
      extensions.fzf-native.enable = true;
    };
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
  };
}
