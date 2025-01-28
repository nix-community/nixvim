{
  empty = {
    plugins.lexima.enable = true;
  };

  defaults = {
    plugins.lexima = {
      enable = true;

      settings = {
        no_default_rules = 0;
        map_escape = "<Esc>";
        enable_basic_rules = 1;
        enable_newline_rules = 1;
        enable_space_rules = 1;
        enable_endwise_rules = 1;
        accept_pum_with_enter = 1;
        ctrlh_as_backspace = 0;
        disable_on_nofile = 0;
        disable_abbrev_trigger = 0;
      };
    };
  };

  example = {
    plugins.lexima = {
      enable = true;

      settings = {
        map_escape = "";
        enable_space_rules = 0;
        enable_endwise_rules = 0;
      };
    };
  };
}
