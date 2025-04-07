{
  empty = {
    plugins.glow.enable = true;
  };

  defaults = {
    plugins.glow = {
      enable = true;

      settings = {
        glow_path.__raw = "vim.fn.exepath('glow')";
        install_path = "~/.local/bin";
        border = "shadow";
        style = "dark";
        pager = false;
        width = 80;
        height = 100;
        width_ratio = 0.7;
        height_ratio = 0.7;
      };
    };
  };

  example = {
    plugins.glow = {
      enable = true;
      settings = {
        border = "single";
        style = "/path/to/catppuccin.json";
      };
    };
  };
}
