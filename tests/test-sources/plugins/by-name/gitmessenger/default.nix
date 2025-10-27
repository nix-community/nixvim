{
  empty = {
    plugins.gitmessenger.enable = true;
  };

  defaults = {
    plugins.gitmessenger = {
      enable = true;

      settings = {
        close_on_cursor_moved = true;
        include_diff = "none";
        git_command = "git";
        no_default_mappings = false;
        into_popup_after_show = true;
        always_into_popup = false;
        extra_blame_args = "";
        preview_mods = "";
        max_popup_height.__raw = "nil";
        max_popup_width.__raw = "nil";
        date_format = "%c";
        conceal_word_diff_marker = true;
        floating_win_opts.__empty = { };
        popup_content_margins = true;
      };
    };
  };

  example = {
    plugins.gitmessenger = {
      enable = true;

      settings = {
        extra_blame_args = "-w";
        include_diff = "current";
        floating_win_opts.border = "single";
      };
    };
  };
}
