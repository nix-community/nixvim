{
  empty = {
    plugins.fyler.enable = true;
  };

  example = {
    plugins.fyler = {
      enable = true;
      settings = {
        auto_confirm_simple_mutation = false;
        bound_cursor = true;
        follow_current_file = true;

        kind = "split_left";
        mappings = {
          i = {
            "jj" = {
              action = "<ESC>";
            };
          };
        };
      };
    };
  };
}
