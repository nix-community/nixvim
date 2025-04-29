{
  empty = {
    plugins.peek.enable = true;
  };

  defaults = {
    plugins.peek = {
      enable = true;

      settings = {
        auto_load = true;
        close_on_bdelete = true;
        syntax = true;
        theme = "dark";
        update_on_change = true;
        app = "webview";
        filetype = [ "markdown" ];
        throttle_at = 200000;
        throttle_time = "auto";
      };
    };
  };

  example = {
    plugins.peek = {
      enable = true;

      settings = {
        auto_load = false;
        close_on_bdelete = false;
        app = "google-chrome-stable";
      };
    };
  };

  withoutUserCommands = {
    plugins.peek = {
      enable = true;
      createUserCommands = false;
    };
  };
}
