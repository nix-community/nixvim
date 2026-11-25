{
  empty = {
    plugins.jujutsu.enable = true;
  };

  defaults = {
    plugins.jujutsu = {
      enable = true;
      settings = {
        keymap = {
          "?" = {
            cmd = "show_help";
            desc = "Show keybindings help";
          };
        };
      };

    };
  };
}
