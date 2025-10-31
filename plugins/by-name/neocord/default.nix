{
  lib,
  ...
}:
lib.nixvim.plugins.mkNeovimPlugin {
  name = "neocord";
  description = "Discord Rich Presence for Neovim (Fork of presence.nvim).";

  maintainers = [ ];

  settingsExample = {
    # General options
    auto_update = true;
    logo = "auto";
    logo_tooltip = null;
    main_image = "language";
    client_id = "1157438221865717891";
    log_level = null;
    debounce_timeout = 10;
    enable_line_number = false;
    blacklist = [ ];
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
}
