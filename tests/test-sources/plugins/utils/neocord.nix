{
  empty = {
    # don't run tests as they try to acess the network.
    tests.dontRun = true;
    plugins.neocord.enable = true;
  };

  defaults = {
    # don't run tests as they try to acess the network.
    tests.dontRun = true;
    plugins.neocord = {
      enable = true;

      settings = {
        # General options.
        logo = "auto";
        logo_tooltip = null;
        main_image = "language";
        client_id = "1157438221865717891";
        log_level = null;
        debounce_timeout = 10;
        blacklist = [];
        file_assets = null;
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
    # don't run tests as they try to acess the network.
    tests.dontRun = true;
    plugins.neocord = {
      enable = true;

      settings = {
        #General options
        auto_update = true;
        logo = "auto";
        logo_tooltip = null;
        main_image = "language";
        client_id = "1157438221865717891";
        log_level = null;
        debounce_timeout = 10;
        enable_line_number = false;
        blacklist = [];
        file_assets = null;
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
