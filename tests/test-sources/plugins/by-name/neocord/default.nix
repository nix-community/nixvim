{
  empty = {
    # don't run tests as they try to access the network.
    test.runNvim = false;
    plugins.neocord.enable = true;
  };

  defaults = {
    # don't run tests as they try to access the network.
    test.runNvim = false;
    plugins.neocord = {
      enable = true;

      settings = {
        # General options.
        logo = "auto";
        logo_tooltip.__raw = "nil";
        main_image = "language";
        client_id = "1157438221865717891";
        log_level.__raw = "nil";
        debounce_timeout = 10;
        blacklist.__empty = { };
        file_assets.__raw = "nil";
        show_time = true;
        global_timer = false;

        # Rich presence text options.
        editing_text = "Editing %s";
        file_explorer_text = "Browsing %s";
        git_commit_text = "Committing changes";
        plugin_manager_text = "Managing plugins";
        reading_text = "Reading %s";
        workspace_text = "Working on %s";
        line_number_text = "Line %s out of %s";
        terminal_text = "Using Terminal";
      };
    };
  };

  example = {
    # don't run tests as they try to access the network.
    test.runNvim = false;
    plugins.neocord = {
      enable = true;

      settings = {
        #General options
        auto_update = true;
        logo = "auto";
        logo_tooltip = "Nixvim";
        main_image = "language";
        client_id = "1157438221865717891";
        log_level.__raw = "nil";
        debounce_timeout = 10;
        enable_line_number = false;
        blacklist.__empty = { };
        file_assets.__raw = "nil";
        show_time = true;
        global_timer = false;

        # Rich Presence text options
        editing_text = "Editing...";
        file_explorer_text = "Browsing...";
        git_commit_text = "Committing changes...";
        plugin_manager_text = "Managing plugins...";
        reading_text = "Reading...";
        workspace_text = "Working on %s";
        line_number_text = "Line %s out of %s";
        terminal_text = "Using Terminal...";
      };
    };
  };
}
