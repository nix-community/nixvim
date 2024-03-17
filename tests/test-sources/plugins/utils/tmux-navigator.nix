{
  # Empty configuration
  empty = {
    plugins.tmux-navigator.enable = true;
  };

  # Activate all settings
  defaults = {
    plugins.tmux-navigator = {
      enable = true;

      keymaps = [ ];

      settings = {
        save_on_switch = 2;
        disable_when_zoomed = true;
        preserve_zoom = true;
        no_wrap = true;
        no_mappings = true;
      };
    };
  };

  with-keymap = {
    plugins.tmux-navigator = {
      enable = true;

      keymaps = [
        {
          key = "<C-w>h";
          action = "left";
        }
        {
          key = "<C-w>j";
          action = "down";
        }
        {
          key = "<C-w>k";
          action = "up";
        }
        {
          key = "<C-w>l";
          action = "right";
        }
        {
          key = "<C-w>\\";
          action = "previous";
        }
      ];

      settings.no_mappings = true;
    };
  };
}
