{
  empty = {
    plugins.presence-nvim.enable = true;
  };

  defaults = {
    plugins.presence-nvim = {
      enable = true;
      settings = {
        auto_update = true;
        neovim_image_text = "The One True Text Editor";
        main_image = "neovim";
        client_id = "793271441293967371";
        log_level = null;
        debounce_timeout = 10;
        enable_line_number = false;
        blacklist = [ ];
        file_assets = null;
        show_time = true;
        buttons = [ ];
        editing_text = "Editing %s";
        file_explorer_text = "Browsing %s";
        git_commit_text = "Committing changes";
        plugin_manager_text = "Managing plugins";
        reading_text = "Reading %s";
        workspace_text = "Working on %s";
        line_number_text = "Line %s out of %s";
      };
    };
  };

  example = {
    plugins.presence-nvim = {
      enable = true;
      settings = {
        auto_update = false;
        neovim_image_text = "The Superior Text Editor";
        main_image = "file";
        editing_text = "Crafting %s";
        workspace_text = "Working on %s";
        enable_line_number = true;
        buttons = [
          {
            label = "GitHub";
            url = "https://github.com/username";
          }
        ];
        blacklist = [
          "NvimTree"
          "alpha"
        ];
      };
    };
  };
}
