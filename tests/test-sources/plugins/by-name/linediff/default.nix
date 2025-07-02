{
  empty = {
    plugins.linediff.enable = true;
  };

  defaults = {
    plugins.linediff = {
      enable = true;

      settings = {
        indent = 0;
        buffer_type = "tempfile";
        first_buffer_command = "tabnew";
        further_buffer_command = "rightbelow vertical new";
        diffopt = "builtin";
        modify_statusline = 0;
        sign_highlight_group = "Search";
      };
    };
  };

  example = {
    plugins.linediff = {
      enable = true;

      settings = {
        modify_statusline = 0;
        first_buffer_command = "topleft new";
        second_buffer_command = "vertical new";
      };
    };
  };
}
