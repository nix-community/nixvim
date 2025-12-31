{
  empty = {
    plugins.iswap.enable = true;
  };

  defaults = {
    plugins.iswap = {
      enable = true;

      settings = {
        keys = "asdfghjklqwertyuiopzxcvbnm";
        hl_grey = "Comment";
        hl_snipe = "Search";
        hl_selection = "Visual";
        flash_style = "sequential";
        hl_flash = "IncSearch";
        hl_grey_priority = 1000;
        grey = "enable";
      };
    };
  };

  example = {
    plugins.iswap = {
      enable = true;

      settings = {
        debug = true;
        move_cursor = true;
      };
    };
  };
}
