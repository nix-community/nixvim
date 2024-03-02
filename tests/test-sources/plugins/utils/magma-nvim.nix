{
  empty = {
    plugins.magma-nvim.enable = true;
  };

  defaults = {
    plugins.magma-nvim = {
      enable = true;

      settings = {
        image_provider = "none";
        automatically_open_output = true;
        wrap_output = true;
        output_window_borders = true;
        cell_highlight_group = "CursorLine";
        save_path.__raw = "vim.fn.stdpath('data') .. '/magma'";
        show_mimetype_debug = false;
      };
    };
  };
}
