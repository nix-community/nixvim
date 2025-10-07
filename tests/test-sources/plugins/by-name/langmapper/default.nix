{
  empty = {
    plugins.langmapper.enable = true;
  };

  defaults = {
    plugins.langmapper = {
      enable = true;

      settings = {
        map_add_ctrl = true;
        ctrl_map_modes = [
          "n"
          "o"
          "i"
          "c"
          "t"
          "v"
        ];
        hack_keymap = true;
        disable_hack_modes = [ "i" ];
        automappings_modes = [
          "n"
          "v"
          "x"
          "s"
        ];
      };
    };
  };
}
