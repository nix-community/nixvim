{
  # Empty configuration
  empty = {
    plugins.tmux-navigator.enable = true;
  };

  # Activate all settings
  defaults = {
    plugins.tmux-navigator = {
      enable = true;

      settings = {
        save_on_switch = 2;
        disable_when_zoomed = true;
        preserve_zoom = true;
        no_wrap = true;
        no_mappings = true;
      };
    };
  };
}
