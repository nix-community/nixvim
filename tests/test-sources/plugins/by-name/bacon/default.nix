{
  empty = {
    plugins.bacon.enable = true;
  };

  defaults = {
    plugins.bacon = {
      enable = true;
      settings = {
        quickfix = {
          enabled = true;
          event_trigger = true;
        };
      };
    };
  };
}
