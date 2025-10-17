{
  empty = {
    plugins.eyeliner.enable = true;
  };

  defaults = {
    plugins.eyeliner = {
      enable = true;
      settings = {
        highlight_on_key = false;
        dim = false;
        max_length = 9999;
        disabled_filetypes = [ ];
        disabled_buftypes = [ ];
        default_keymaps = true;
      };
    };
  };

  example = {
    plugins.eyeliner = {
      enable = true;
      settings = {
        highlight_on_key = true;
        dim = true;
      };
    };
  };
}
