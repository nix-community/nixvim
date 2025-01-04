{
  empty = {
    plugins.treesj.enable = true;
  };

  defaults = {
    plugins.treesj = {
      enable = true;

      settings = {
        use_default_keymaps = true;
        check_syntax_error = true;
        max_join_length = 120;
        cursor_behavior = "hold";
        notify = true;
        dot_repeat = true;
        on_error.__raw = "nil";
        langs = { };
      };
    };
  };

  example = {
    plugins.treesj = {
      enable = true;

      settings = {
        cursor_behavior = "start";
        max_join_length = 80;
        dot_repeat = false;
        langs = {
          r = {
            arguments.__raw = ''
              require("treesj.langs.utils").set_preset_for_args({
                both = {
                  separator = "comma",
                },
                split = {
                  recursive_ignore = { "subset" },
                },
              })
            '';
            parameters.__raw = ''
              require("treesj.langs.utils").set_preset_for_args({
                both = {
                  separator = "comma",
                },
                split = {
                  recursive_ignore = { "subset" },
                },
              })
            '';
            left_assignment = {
              target_nodes = [
                "arguments"
                "parameters"
              ];
            };
          };
        };
      };
    };
  };
}
