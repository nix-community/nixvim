{
  empty = {
    plugins.committia.enable = true;
  };

  default = {
    plugins.committia = {
      enable = true;

      settings = {
        open_only_vim_starting = 1;
        use_singlecolumn = "always";
        min_window_width = 160;
        status_window_opencmd = "belowright split";
        diff_window_opencmd = "botright vsplit";
        singlecolumn_diff_window_opencmd = "belowright split";
        edit_window_width = 80;
        status_window_min_height = 0;
      };
    };
  };

  no-packages = {
    plugins.committia.enable = true;

    dependencies.git.enable = false;
  };
}
