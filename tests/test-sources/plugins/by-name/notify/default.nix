{
  empty = {
    plugins.notify.enable = true;
  };

  defaults = {
    plugins.notify = {
      enable = true;

      settings = {
        level = "info";
        timeout = 5000;
        max_width.__raw = "nil";
        max_height.__raw = "nil";
        stages = "fade_in_slide_out";
        background_colour = "NotifyBackground";
        icons = {
          error = "";
          warn = "";
          info = "";
          debug = "";
          trace = "✎";
        };
        on_open.__raw = "nil";
        on_close.__raw = "nil";
        render = "default";
        minimum_width = 50;
        fps = 30;
        top_down = true;
      };
    };
  };
}
