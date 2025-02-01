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
        max_width = null;
        max_height = null;
        stages = "fade_in_slide_out";
        background_colour = "NotifyBackground";
        icons = {
          error = "";
          warn = "";
          info = "";
          debug = "";
          trace = "✎";
        };
        on_open = null;
        on_close = null;
        render = "default";
        minimum_width = 50;
        fps = 30;
        top_down = true;
      };
    };
  };
}
