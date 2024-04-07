{
  empty = {
    plugins.debugprint.enable = true;
  };

  example = {
    plugins.debugprint = {
      enable = true;

      settings = {
        keymaps = {
          normal = {
            plain_below = "g?p";
            plain_above = "g?P";
            variable_below = "g?v";
            variable_above = "g?V";
            variable_below_alwaysprompt.__raw = "nil";
            variable_above_alwaysprompt.__raw = "nil";
            textobj_below = "g?o";
            textobj_above = "g?O";
            toggle_comment_debug_prints.__raw = "nil";
            delete_debug_prints.__raw = "nil";
          };
          visual = {
            variable_below = "g?v";
            variable_above = "g?V";
          };
        };
        commands = {
          toggle_comment_debug_prints = "ToggleCommentDebugPrints";
          delete_debug_prints = "DeleteDebugPrints";
        };
        move_to_debugline = false;
        display_counter = true;
        display_snippet = true;
        filetypes = {
          python = {
            left = "print(f'";
            right = "')";
            mid_var = "{";
            right_var = "}')";
          };
        };
        ignore_treesitter = false;
        print_tag = "DEBUGPRINT";
      };
    };
  };
}
