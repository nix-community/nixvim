{
  empty = {
    plugins.nvim-osc52.enable = true;
  };

  defaults = {
    plugins.nvim-osc52 = {
      maxLength = 0;
      silent = false;
      trim = false;

      keymaps = {
        silent = false;
        enable = true;
      };
    };
  };
}
