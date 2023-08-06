{
  empty = {
    plugins.fidget.enable = true;
  };

  defaults = {
    plugins.fidget = {
      enable = true;

      text = {
        spinner = "pipe";
        done = "✔";
        commenced = "Started";
        completed = "Completed";
      };
      align = {
        bottom = true;
        right = true;
      };
      timer = {
        spinnerRate = 125;
        fidgetDecay = 2000;
        taskDecay = 1000;
      };
      window = {
        relative = "win";
        blend = 100;
        zindex = null;
        border = "none";
      };
      fmt = {
        leftpad = true;
        stackUpwards = true;
        maxWidth = 0;
        fidget.__raw = ''
          function(fidget_name, spinner)
            return string.format("%s %s", spinner, fidget_name)
          end
        '';
        task.__raw = ''
          function(task_name, message, percentage)
            return string.format(
              "%s%s [%s]",
              message,
              percentage and string.format(" (%s%%)", percentage) or "",
              task_name
            )
          end
        '';
      };
      debug = {
        logging = false;
        strict = false;
      };
    };
  };
}
