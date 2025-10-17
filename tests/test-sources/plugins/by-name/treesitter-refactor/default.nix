{
  empty = {
    plugins = {
      treesitter.enable = true;
      treesitter-refactor.enable = true;
    };
  };

  example = {
    plugins = {
      treesitter.enable = true;
      treesitter-refactor = {
        enable = true;

        settings = {
          smart_rename = {
            enable = true;
            keymaps.smart_rename = "grr";
          };
        };
      };
    };
  };
}
