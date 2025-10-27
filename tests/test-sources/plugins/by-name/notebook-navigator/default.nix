{
  empty = {
    plugins = {
      notebook-navigator.enable = true;
      molten.enable = true;
    };
  };

  defaults = {
    plugins = {
      molten.enable = true;
      notebook-navigator = {
        enable = true;

        settings = {
          cell_markers.__empty = { };
          activate_hydra_keys.__raw = "nil";
          show_hydra_hint = true;
          hydra_keys = {
            comment = "c";
            run = "X";
            run_and_move = "x";
            move_up = "k";
            move_down = "j";
            add_cell_before = "a";
            add_cell_after = "b";
            split_cell = "s";
          };
          repl_provider = "auto";
          syntax_highlight = false;
          cell_highlight_group = "Folded";
        };
      };
    };
  };

  example = {
    # ERROR: [Hydra.nvim] Option "hint.border" has been deprecated and will be removed on 2024-02-01 -- See hint.float_opts
    test.runNvim = false;

    plugins = {
      hydra.enable = true;
      molten.enable = true;
      notebook-navigator = {
        enable = true;

        settings = {
          cell_markers.python = "# %%";
          activate_hydra_keys = "<leader>h";
          hydra_keys = {
            comment = "c";
            run = "X";
            run_and_move = "x";
            move_up = "k";
            move_down = "j";
            add_cell_before = "a";
            add_cell_after = "b";
            split_cell = "s";
          };
          repl_provider = "molten";
          syntax_highlight = true;
          cell_highlight_group = "Folded";
        };
      };
    };
  };
}
