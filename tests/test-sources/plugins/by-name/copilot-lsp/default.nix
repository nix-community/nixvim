{
  empty = {
    plugins.copilot-lsp.enable = true;
  };

  defaults = {
    plugins.copilot-lsp = {
      enable = true;
      settings = {
        move_count_threshold = 3;
        distance_threshold = 40;
        clear_on_large_distance = true;
        count_horizontal_moves = true;
        reset_on_approaching = true;
      };
    };
  };
}
