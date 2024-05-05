{
  empty = {
    plugins.smart-splits.enable = true;
  };

  example = {
    plugins.smart-splits = {
      enable = true;

      settings = {
        ignored_filetypes = [
          "nofile"
          "quickfix"
          "prompt"
        ];
        ignored_buftypes = [ "NvimTree" ];
        default_amount = 3;
        move_cursor_same_row = true;
        cursor_follows_swapped_bufs = true;
        resize_mode = {
          quit_key = "<ESC>";
          resize_keys = [
            "h"
            "j"
            "k"
            "l"
          ];
          silent = true;
        };
      };
    };
  };
}
