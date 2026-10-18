{
  empty = {
    plugins.smart-splits.enable = true;
  };

  example = {
    plugins.smart-splits = {
      enable = true;

      settings = {
        ignored_filetypes = [ "NvimTree" ];
        ignored_buftypes = [
          "nofile"
          "quickfix"
          "prompt"
        ];
        resize = {
          amount = 3;
          ignored_events = [
            "BufEnter"
            "WinEnter"
          ];
        };
        move = {
          at_edge = "wrap";
          same_row = true;
        };
        swap.move_cursor = true;
      };
    };
  };
}
