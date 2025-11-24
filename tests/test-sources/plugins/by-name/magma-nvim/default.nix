{ pkgs }:
{
  empty = {
    # NOTE: 2024-10-10 when marked as linux specific platform
    plugins.magma-nvim.enable = pkgs.stdenv.isLinux;
  };

  defaults = {
    plugins.magma-nvim = {
      # NOTE: 2024-10-10 when marked as linux specific platform
      enable = pkgs.stdenv.isLinux;

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
