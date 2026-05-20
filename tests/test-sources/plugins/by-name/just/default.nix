{
  empty = {
    plugins.just.enable = true;
  };

  defaults = {
    plugins.just = {
      enable = true;
      settings = {
        fidget_message_limit = 32;
        play_sound = false;
        open_qf_on_error = true;
        open_qf_on_run = true;
        telescope_borders = {
          prompt = [
            "─"
            "│"
            " "
            "│"
            "┌"
            "┐"
            "│"
            "│"
          ];
          results = [
            "─"
            "│"
            "─"
            "│"
            "├"
            "┤"
            "┘"
            "└"
          ];
          preview = [
            "─"
            "│"
            "─"
            "│"
            "┌"
            "┐"
            "┘"
            "└"
          ];
        };
      };
    };
  };

  example = {
    plugins.just = {
      enable = true;
      settings = {
        fidget_message_limit = 64;
        play_sound = true;
        open_qf_on_run = false;
        telescope_borders = {
          prompt = [
            " "
            " "
            " "
            " "
            " "
            " "
            " "
            " "
          ];
          results = [
            " "
            " "
            " "
            " "
            " "
            " "
            " "
            " "
          ];
          preview = [
            " "
            " "
            " "
            " "
            " "
            " "
            " "
            " "
          ];
        };
      };
    };
  };
}
