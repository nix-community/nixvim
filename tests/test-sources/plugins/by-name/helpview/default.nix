{
  empty = {
    plugins.helpview.enable = true;
  };

  defaults = {
    plugins.helpview = {
      enable = true;

      settings = {
        buf_ignore = null;
        mode = [
          "n"
          "c"
        ];
        hybrid_modes = null;
        callback = {
          on_enable = null;
          on_disable = null;
          on_mode_change = null;
        };
      };
    };
  };
}
