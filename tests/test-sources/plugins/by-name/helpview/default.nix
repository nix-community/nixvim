{
  empty = {
    plugins.helpview.enable = true;
  };

  defaults = {
    plugins.helpview = {
      enable = true;

      settings = {
        buf_ignore.__raw = "nil";
        mode = [
          "n"
          "c"
        ];
        hybrid_modes.__raw = "nil";
        callback = {
          on_enable.__raw = "nil";
          on_disable.__raw = "nil";
          on_mode_change.__raw = "nil";
        };
      };
    };
  };
}
