{
  empty = {
    plugins = {
      codecompanion = {
        enable = true;
        extensions.history.enable = true;
      };
      snacks.enable = true;
    };
  };

  defaults = {
    plugins = {
      snacks.enable = true;
      codecompanion = {
        enable = true;

        extensions.history = {
          enable = true;

          settings = {
            keymap = "gh";
            auto_generate_title = true;
            continue_last_chat = false;
          };
        };
      };
    };
  };

  example = {
    plugins = {
      snacks.enable = true;
      codecompanion = {
        enable = true;

        extensions.history = {
          enable = true;

          settings = {
          };
        };
      };
    };
  };
}
