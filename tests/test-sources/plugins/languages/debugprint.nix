{
  default = {
    plugins.debugprint = {
      create_keymaps = true;
      display_counter = true;
      display_snippet = true;
      enable = false;
      filetypes = {};
      ignore_treesitter = false;
      move_to_debugline = false;
      print_tag = "DEBUGPRINT";
    };
  };

  empty.plugins.debugprint.enable = true;

  example = {
    plugins.debugprint = {
      create_keymaps = false;
      display_counter = false;
      display_snippet = false;
      enable = true;
      filetypes = {};
      ignore_treesitter = true;
      move_to_debugline = true;
      print_tag = "DEBUG";
    };
  };
}
