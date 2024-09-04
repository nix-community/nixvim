{
  empty = {
    plugins.nvim-osc52.enable = true;

    # Hide warnings, since this plugin is deprecated
    test.checkWarnings = false;
  };

  defaults = {
    plugins.nvim-osc52 = {
      enable = true;

      maxLength = 0;
      silent = false;
      trim = false;

      keymaps = {
        silent = false;
        enable = true;
      };
    };

    # Hide warnings, since this plugin is deprecated
    test.checkWarnings = false;
  };
}
