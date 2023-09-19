{
  empty = {
    plugins.notify.enable = true;
  };

  defaults = {
    plugins.notify = {
      enable = true;

      level.__raw = "vim.log.levels.INFO";
      timeout = 5000;
      maxWidth = null;
      maxHeight = null;
      stages = "fade_in_slide_out";
      backgroundColour = "NotifyBackground";
      icons = {
        error = "";
        warn = "";
        info = "";
        debug = "";
        trace = "✎";
      };
      onOpen = null;
      onClose = null;
      render = "default";
      minimumWidth = 50;
      fps = 30;
      topDown = true;
    };
  };
}
