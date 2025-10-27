{
  empty = {
    plugins.trim.enable = true;
  };

  defaults = {
    plugins.trim = {
      enable = true;

      settings = {
        ft_blocklist.__empty = { };
        patterns.__empty = { };
        trim_on_write = true;
        trim_trailing = true;
        trim_last_line = true;
        trim_first_line = true;
        highlight = false;
        highlight_bg = "#ff0000";
        highlight_ctermbg = "red";
      };
    };
  };

  example = {
    plugins.trim = {
      enable = true;

      settings = {
        ft_blocklist = [ "markdown" ];
        patterns = [ "[[%s/\(\n\n\)\n\+/\1/]]" ];
        trim_on_write = false;
        highlight = true;
      };
    };
  };
}
