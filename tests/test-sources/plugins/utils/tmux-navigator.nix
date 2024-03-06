{
  # Empty configuration
  empty = {
    plugins.tmux-navigator.enable = true;
  };

  # Activate all settings
  defaults = {
    plugins.tmux-navigator = {
      enable = true;

      tmuxNavigatorSaveOnSwitch = 2;

      tmuxNavigatorDisableWhenZoomed = 1;

      tmuxNavigatorNoWrap = 1;
    };
  };
}
